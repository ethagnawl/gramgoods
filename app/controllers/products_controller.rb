class ProductsController < ApplicationController
  def new
    @product = Product.new
    @store = params[:store_id]
    @product.store_id = @store
  end

  def create
    @product = Product.new(params[:product])
    @store = params[:product][:store_id]
    if @product.save
      redirect_to(store_product_path(@store, @product))
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
    @store = params[:store_id]
  end

  def edit
    @product = Product.find(params[:id])
    @store = params[:store_id]
  end

  def update
    @product = Product.find(params[:id])
    @store = params[:product][:store_id]
    if @product.update_attributes(params[:product])
      redirect_to(store_product_path(@store, @product))
    else
      render 'edit'
    end
  end
end
