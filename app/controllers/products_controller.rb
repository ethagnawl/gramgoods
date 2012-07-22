class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :except => [:show, :index] do |controller|
    controller.instance_eval do
      if store_id = (params[:store_id] || params[:product][:store_id])
        redirect_to(root_path) unless user_owns_store?(store_id)
      else
        redirect_to(root_path)
      end
    end
  end

  def new
    @user = current_user
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
    @store = Store.find(params[:store_id])
    @user = User.find(Integer(@store.user_id))
  end

  def edit
    @user = current_user
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
