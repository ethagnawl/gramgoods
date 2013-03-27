class OrdersController < ApplicationController
  layout 'mobile'
  before_filter :authenticate_user!, :only => [:index]

  def index
    @store = Store.find(params[:store_id], :include => {
                                              :orders => [:store, :line_item]})
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

    if params[:store_id] && params[:product_id]
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
      @flatrate_shipping_option = @product.valid_flatrate_shipping_option?(params[:flatrate_shipping_option]) ? params[:flatrate_shipping_option] : nil


      unless @flatrate_shipping_option.nil?
        @flatrate_shipping_option_cost = @product.flatrate_shipping_option_cost(@flatrate_shipping_option)
        @total += @flatrate_shipping_option_cost
      end
    else
      flash[:alert] = @order.stripe_error_message
      redirect_to products_path
    end
  end

  def create
    original_params = params.clone
    @store = Store.find(params[:store_id])
    @recipient = params[:recipient_attributes]
    @line_item = params[:line_item_attributes]
    @product = @store.products.find(params[:order][:line_item_attributes][:product_id])
    @quantity = params[:order][:line_item_attributes][:quantity].to_i
    @color = params[:order][:line_item_attributes][:color]
    @size = params[:order][:line_item_attributes][:size]
    @price = @product.price
    @total = @quantity * @price

    @flatrate_shipping_option = @product.valid_flatrate_shipping_option?(params[:order][:line_item_attributes][:flatrate_shipping_option]) ? params[:order][:line_item_attributes][:flatrate_shipping_option] : nil
    unless @flatrate_shipping_option.nil?
      @flatrate_shipping_option_cost = @product.flatrate_shipping_option_cost(@flatrate_shipping_option)
      @total += @flatrate_shipping_option_cost
    end

    params[:order][:line_item_attributes][:product_name] = @product.name
    params[:order][:line_item_attributes][:price] = @price
    params[:order][:line_item_attributes][:total] = @total

    @order = @store.orders.new(params[:order])

    if @order.save_with_payment(params[:stripeToken])
      redirect_to confirmation_store_order_path @store, @order.access_key
    else
      flash[:notice] = @order.stripe_error_message
      redirect_to(:back)
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
