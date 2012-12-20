class ProductsController < ApplicationController
  layout 'mobile'
  before_filter :strip_commas_from_prices, :only => [:create, :update]
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
    @products = Product.recent_active_products.page(params[:page]).
      per_page(PRODUCT_PAGINATION_SIZE)

    gon.max_pagination_page = @max_pagination_page = @products.total_pages
    gon.products_json = products_json = products_json(@products)

    @show_view_more_products_button = show_view_more_products_button?(
                                        @max_pagination_page)

    respond_to do |format|
      format.html
      format.json do
        render :json => {
          :products_json => products_json
        }
      end
    end
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
    @is_customized_store = is_store_slug_in_merchants_with_custom_store_slugs_array? @store.slug
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
      redirect_to(custom_store_path(@store))
    else
      render 'show'
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
    # TODO add money gem and convert price to integer
    def strip_commas_from_prices
      params[:product][:price] = params[:product][:price].gsub(',', '')
      unless params[:product][:flatrate_shipping_cost].nil?
        params[:product][:flatrate_shipping_cost] = params[:product][:flatrate_shipping_cost].gsub(',', '')
      end
    end

    def conditionally_redirect_to_instagram_app(store, product)
        product_path = custom_product_path(store, product)
        unless params[:post_to_instagram].nil?
          product_path << "?redirect_to_instagram=true"
        end
        redirect_to(product_path)
    end

    def redirect_to_current_slug
      @product = begin
          id = params[:id].downcase
          Product.find(id)
        rescue
          nil
      end

      if @product.nil?
        redirect_to root_path
      else
        params[:format] = nil if params[:format] == 'html'
        if request.path != custom_product_path(@product.store, @product)
          redirect_to custom_product_path(@product.store, @product, params),
            :status => :moved_permanently
        end
      end
    end
end
