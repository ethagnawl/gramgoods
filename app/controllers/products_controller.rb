class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :except => [:show, :index, :destroy] do |controller|
    # why won't this work for :destroy?
    controller.instance_eval do
      if store = Store.find((params[:store_id] || params[:product][:store_id]))
        redirect_to(root_path) unless user_owns_store?(store.id)
      else
        redirect_to(root_path)
      end
    end
  end

  # redirect old urls to new urls
  #if request.path != store_path(@store)
  #  redirect_to(@store, :status => :moved_permanently)
  #end

  def index
    redirect_to(store_path(Store.find(params[:store_id])))
  end

  def new
    @user = current_user
    @product = Product.new
    @store = Store.find(params[:store_id])
  end

  def create
    @product = Product.new(params[:product])
    @store = Store.find(params[:product][:store_id])
    product_photos_is_empty = params[:product][:photos].empty?
    @product.status = 'Draft' if product_photos_is_empty
    if @product.save
      if product_photos_is_empty
        flash[:notice] = product_photos_empty_message(@product.name)
      end
      redirect_to(store_product_path(@store, @product))
    else
       render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
    @store = Store.find(params[:store_id])
    @user = User.find(Integer(@store.user_id))
    render_conditional_layout(params[:layout])
  end

  def edit
    @user = current_user
    @product = Product.find(params[:id])
    @store = Store.find(params[:store_id])
  end

  def update
    @product = Product.find(params[:id])
    @store = Store.find(params[:product][:store_id])
    product_photos_is_empty = params[:product][:photos].empty?
    params[:product][:status] = 'Draft' if product_photos_is_empty
    if @product.update_attributes(params[:product])
      if product_photos_is_empty
        flash[:notice] = product_photos_empty_message(@product.name)
      end
      redirect_to(store_product_path(@store, @product))
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:product])
    @store = Store.find(Integer(@product.store_id))

    if user_owns_store?(@store.id)
      @product.destroy
      flash[:notice] = "#{@product.name} was successfully deleted."
      redirect_to(store_path(@store))
    else
      redirect_to(root_path)
    end
  end

  private

  def product_photos_empty_message(name)
    "You will need to attach at least one image to #{name} before setting status to Active."
  end

  def user_owns_store?(store_id)
    current_user.store_ids.include?(store_id)
  end
end
