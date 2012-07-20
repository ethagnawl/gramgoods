class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to product_path(@product)
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
