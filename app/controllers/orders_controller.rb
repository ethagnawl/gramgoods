class OrdersController < ApplicationController
  layout 'mobile'
  force_ssl
  before_filter :authenticate_user!, :only => [:index]

  def index
    @store = Store.find(params[:store_id])
    render :layout => 'admin'
  end

  def show
    render 'orders/show.mobile.html.haml'
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
    render 'orders/new.mobile.html.haml'
  end

  def create
    @store = Store.find(params[:store_id])
    @order = @store.orders.new(params[:order])
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

    stripe_total = (@order.line_item.total * 100).to_i
    token = params[:stripeToken]

    if @order.save && @order.charge(stripe_total, token)
      @order.update_attributes({ :status => 'success' })
      @order.line_item.product.deduct_from_quantity(@order.line_item.quantity)
      OrderMailer.order_confirmation(@order).deliver
      render 'orders/show.mobile.html.haml'
    else
      render 'orders/new.mobile.html.haml'
    end
  end
end
