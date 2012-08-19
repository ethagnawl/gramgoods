class OrdersController < ApplicationController
  layout 'mobile'
  force_ssl

  def show
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

    if @order.save
      total = (@order.line_item.total * 100).to_i
      token = params[:stripeToken]
      charge = Stripe::Charge.create(
        :amount => total,
        :currency => "usd",
        :card => token,
        :description => "GramGoods purchase test"
      )

      @order.update_attributes({ :status => 'success' })

      product = Product.find(@order.line_item.product_id)
      product.deduct_from_quantity(@order.line_item.quantity)
      OrderMailer.order_confirmation(@order, product).deliver

      @product = product
      render 'show'
    else
      render 'new'
    end
  end
end
