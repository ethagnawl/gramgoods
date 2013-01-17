class OrdersController < ApplicationController
  layout 'mobile'
  force_ssl
  before_filter :authenticate_user!, :only => [:index]

  def index
    @store = Store.find(params[:store_id], :include => {
                                              :orders => [:line_item, :recipient]})
    if @store.nil?
      redirect_to root_path
    elsif !user_owns_store? @store.id
      redirect_to root_path
    else
      render 'index'
    end
  end

  def show
    @order = Order.find_by_id(params[:id])

    if @order.nil?
      redirect_to root_path
    elsif !user_owns_store? @order.store.id
      redirect_to root_path
    else
      render 'show'
    end
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
    unless @product.international_flatrate_shipping_cost.nil?
      @international_flatrate_shipping_cost = @product.international_flatrate_shipping_cost
      @total += @international_flatrate_shipping_cost
    end

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
    unless @product.international_flatrate_shipping_cost.nil?
      @international_flatrate_shipping_cost = @product.international_flatrate_shipping_cost
      @total += @international_flatrate_shipping_cost
    end

    params[:order][:line_item_attributes][:product_name] = @product.name
    params[:order][:line_item_attributes][:price] = @price
    params[:order][:line_item_attributes][:total] = @total
    unless @flatrate_shipping_cost.nil?
      params[:order][:line_item_attributes][:flatrate_shipping_cost] = @flatrate_shipping_cost
    end
    unless @international_flatrate_shipping_cost.nil?
      params[:order][:line_item_attributes][:international_flatrate_shipping_cost] = @international_flatrate_shipping_cost
    end

    @order = @store.orders.new(params[:order])

    if @order.charge(params[:stripeToken]) && @order.save
      redirect_to confirmation_store_order_path @store, @order.access_key
    else
      render 'new'
    end
  end

  def confirmation
    @order = Order.find_by_access_key(params[:id])
    @store = @order.store

    if @order.nil?
      redirect_to root_path
    end
  end
end
