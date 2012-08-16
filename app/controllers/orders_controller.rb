class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  layout 'mobile'
  respond_to :html, :json

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
  end

  def create
    @store = Store.find(params[:store_id])
    @order = @store.orders.new(params[:order])
    if @order.save
      total = @order.line_item.total * 100
      token = params[:stripeToken]
      charge = Stripe::Charge.create(
        :amount => 1000,
        :currency => "usd",
        :card => token,
        :description => "GramGoods purchase test"
      )

      @order.update_attributes({ :status => 'success' })

      product = Product.find(@order.line_item.product_id)
      product.deduct_from_quantity(@order.line_item.quantity)
      OrderMailer.order_confirmation(@order.recipient.email_address).deliver

      respond_to do |format|
        format.json {
          render :json => { :status => "success" }
        }
        format.html {
          render 'show'
        }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end
end
