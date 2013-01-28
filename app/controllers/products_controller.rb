class ProductsController < ApplicationController
  layout 'mobile'
  before_filter :set_flatrate_shipping_options_in_gon
  before_filter :common_vars, :except => [:index, :show]
  before_filter :strip_commas_from_prices, :only => [:create, :update]
  before_filter :normalize_shipping_option_params, :only => [:create, :update]
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
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new({
                                     :colors => [Color.new],
                                     :sizes => [Size.new]})
  end

  def create
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new(params[:product])
    #TODO: move into after_save callback
    @product.status = 'Out of Stock' if @product.quantity.to_i == 0 && @product.unlimited_quantity == 0

    if @product.save
      redirect_to custom_product_path(@store, @product)
    else
      render 'new'
    end
  end

  def show
    @store = Store.find(params[:store_id])
    @product = ProductDecorator.decorate @store.products.find(params[:id])
    @is_customized_store = @store.is_slug_in_merchants_with_custom_store_slugs_array?
    gon.price = number_with_precision(@product.price, :precision => 2)
    gon.product_name = @product.name
    gon.product_id = @product.id
    gon.store_slug = @store.slug
    gon.create_order_url = new_store_order_path(@store)
    gon.require_flatrate_shipping_option = !@product.flatrate_shipping_options.empty?

    if @product.status == 'Draft'
      if user_signed_in? && (user_owns_store?(@store.id) || current_user.username == 'gramgoods')
        render 'show'
      else
        redirect_to(custom_store_path(@store))
      end
    else
      render 'show'
    end
  end

  def edit
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
    gon.product_images = @product.get_product_images
  end

  def update
    @store = current_user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
    @product.colors.destroy_all
    @product.sizes.destroy_all

    if @product.update_attributes(params[:product])
      redirect_to custom_product_path(@store, @product)
    else
      render 'edit'
    end
  end

  def destroy
    @store = Store.find(params[:store_id])
    @product = @store.products.find(params[:id])

    if user_owns_store?(@store.id)
      @product.destroy
      flash[:notice] = "#{@product.name} has been successfully deleted."
      redirect_to(custom_store_path(@store))
    else
      redirect_to(root_path)
    end
  end

  private
    def common_vars
      @user = current_user
    end

    # TODO add money gem and convert price to integer
    def strip_commas_from_prices
      params[:product][:price] = params[:product][:price].gsub(',', '')
      unless params[:product][:flatrate_shipping_cost].nil?
        params[:product][:flatrate_shipping_cost] = params[:product][:flatrate_shipping_cost].gsub(',', '')
      end
      unless params[:product][:international_flatrate_shipping_cost].nil?
        params[:product][:international_flatrate_shipping_cost] = params[:product][:international_flatrate_shipping_cost].gsub(',', '')
      end
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

    def normalize_shipping_option_params
      Product.flatrate_shipping_options.each do |flatrate_shipping_option|
        params[:product]["#{flatrate_shipping_option}_flatrate_shipping_cost"] = params[:product]["#{flatrate_shipping_option}_flatrate_shipping_cost"].nil? || params[:product]["#{flatrate_shipping_option}_flatrate_shipping_cost"].empty? ? nil : params[:product]["#{flatrate_shipping_option}_flatrate_shipping_cost"]
      end
    end

    def set_flatrate_shipping_options_in_gon
      gon.flatrate_shipping_options = Product.flatrate_shipping_options
    end
end
