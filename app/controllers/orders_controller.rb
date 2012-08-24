class OrdersController < ApplicationController
  layout 'mobile'
  force_ssl
  before_filter :authenticate_user!, :only => [:index]

  def index
    @store = Store.find(params[:store_id], :include => {
                                              :orders => [:line_item, :recipient]})
    render :layout => 'admin'
  end

  def show
    render 'orders/show.mobile'
  end

  def new
    @order = Order.new
    @recipient = @order.build_recipient
    @line_item = @order.build_line_item
    quantity = params[:quantity].to_i
    @store = Store.find(params[:store_id])
    @product = @store.products.find(params[:product_id])
    @quantity = quantity >= 1 ? quantity : 1
    @color = params[:color] unless params[:color].nil?
    @size = params[:size] unless params[:size].nil?
    @price = @product.price
    @total = @quantity * @price
    unless @product.flatrate_shipping_cost.nil?
      @flatrate_shipping_cost = @product.flatrate_shipping_cost
      @total += @flatrate_shipping_cost
    end
    render 'orders/new.mobile'
  end

  def create
    @store = Store.find(params[:store_id])
    @recipient = params[:recipient_attributes]
    @line_item = params[:line_item_attributes]
    @product = @store.products.find(params[:order][:line_item_attributes][:product_id])
    @quantity = params[:order][:line_item_attributes][:quantity].to_i
    @color = params[:order][:line_item_attributes][:color]
    @size = params[:order][:line_item_attributes][:size]
    @price = @product.price
    @total = @quantity * @price
    unless @product.flatrate_shipping_cost.nil?
      @flatrate_shipping_cost = @product.flatrate_shipping_cost
      @total += @flatrate_shipping_cost
    end
    params[:order][:line_item_attributes][:product_name] = @product.name
    params[:order][:line_item_attributes][:price] = @price
    params[:order][:line_item_attributes][:total] = @total
    unless @flatrate_shipping_cost.nil?
      params[:order][:line_item_attributes][:flatrate_shipping_cost] = @flatrate_shipping_cost
    end
    @order = @store.orders.new(params[:order])

    if @order.charge(params[:stripeToken]) && @order.save
      render 'orders/show.mobile'
    else
      render 'orders/new.mobile'
    end
  end
end
