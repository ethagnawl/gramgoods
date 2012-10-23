class ProductsController < ApplicationController
  layout 'mobile'
  before_filter :redirect_to_current_slug, :only => :show
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

  def index
    @products = Product.recent_active_products.page(params[:page]).per_page(5)
  end

  def new
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new({
                                     :instagram_tag => InstagramTag.new,
                                     :colors => [Color.new],
                                     :sizes => [Size.new]})
  end

  def create
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new(params[:product])
    #TODO: move into after_save callback
    @product.status = 'Out of Stock' if @product.quantity.to_i == 0 && @product.unlimited_quantity == 0
    if @product.save
      conditionally_redirect_to_instagram_app @store, @product
    else
      render 'new'
    end
  end

  def show
    @store = Store.find(params[:store_id])
    @product = @store.products.find(params[:id])
    gon.price = number_with_precision(@product.price, :precision => 2)
    gon.product_name = @product.name
    gon.product_id = @product.id
    gon.store_slug = @store.slug
    gon.create_order_url = new_store_order_path(@store)
    unless params[:redirect_to_instagram].nil?
      instagram_params = URI.encode("?caption=#{@product.get_instagram_caption}")
      gon.instagram_protocol_with_params = "instagram://camera" << instagram_params
    end

    if @product.status == 'Draft' && !user_signed_in?
      redirect_to(custom_store_path(@store.slug))
    else
      render 'products'
    end
  end

  def edit
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
  end

  def update
    @store = current_user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
    @product.colors.destroy_all
    @product.sizes.destroy_all
    if @product.update_attributes(params[:product])
      conditionally_redirect_to_instagram_app @store, @product
    else
      render 'edit'
    end
  end

  def destroy
    @store = Store.find(params[:store_id])
    @product = @store.products.find(params[:id])

    if user_owns_store?(@store.id)
      @product.destroy
      notice = "#{@product.name} has been successfully deleted."
      flash[:notice] = notice
      redirect_to(custom_store_path(@store))
    else
      redirect_to(root_path)
    end
  end

  private
    def conditionally_redirect_to_instagram_app(store, product)
        product_path = custom_product_path(store, product)
        unless params[:post_to_instagram].nil?
          product_path << "?redirect_to_instagram=true"
        end
        redirect_to(product_path)
    end

    def redirect_to_current_slug
      @product = Product.find(params[:id])
      if request.path != custom_product_path(@product.store, @product)
        redirect_to custom_product_path(@product.store, @product, params),
          status: :moved_permanently
      end
    end
end
