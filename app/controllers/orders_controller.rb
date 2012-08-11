class OrdersController < ApplicationController
  def create
    @order = Order.new(params[:order])
    if @order.save
      total = @order.line_items.inject(0) { |sum, line_item| sum + line_item.total }
      total = total * 100
      token = params[:stripeToken]
      charge = Stripe::Charge.create(
        :amount => 1000,
        :currency => "usd",
        :card => token,
        :description => "GramGoods purchase test"
      )
      render :json => { :status => "success" }
    else
      render :json => {
        :status => 'error',
        :errors => @product.errors.full_messages.map do |message|
          { :error => message }
        end
      }
    end
  end
end
