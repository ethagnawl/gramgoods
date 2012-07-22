class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def new
    @product = Product.new
    @store = params[:store_id]
    @product.store_id = @store
  end

  def create
    if user_owns_store?(params[:product][:store_id])
      @product = Product.new(params[:product])
      @store = params[:product][:store_id]
      if @product.save
        redirect_to(store_product_path(@store, @product))
      else
        render 'new'
      end
    else
      redirect_to root_path
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

  private

  def user_owns_store?(store_id)
    current_user.store_ids.include?(Integer(store_id))
  end
end
