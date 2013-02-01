class StoresController < ApplicationController
  layout 'mobile'
  before_filter :redirect_to_current_slug, :only => :show
  before_filter :authenticate_user!, :except => [:show, :new, :proxy, :return_policy]
  before_filter :except => [:welcome, :return_policy, :proxy, :create, :new,
    :show, :index, :destroy] do |controller|
    # why won't this work for :destroy?
    controller.instance_eval do
      if store = Store.find(params[:id])
        redirect_to(custom_store_path(store)) unless user_owns_store?(store.id)
      else
        redirect_to(root_path)
      end
    end
  end

  def index
    @user = current_user
    @stores = @user.stores if user_signed_in?
  end

  def proxy
    @user = User.new params[:user]
    @store = Store.new params[:store]
    instagram_auth_url_with_params = "#{INSTAGRAM_CONFIG['AUTH_URL']}?" << params.to_query

    if @user.valid? && @store.valid?
      redirect_to instagram_auth_url_with_params
    else
      render 'new'
    end
  end

  def welcome
    @store = Store.find_by_slug(params[:id])
    redirect_to root_path if @store.nil?
  end

  def return_policy
    @store = Store.find_by_slug(params[:id])
    redirect_to root_path if @store.nil?
  end

  def new
    @user = User.new
    @store = Store.new

    if !current_user.nil? && !current_user.first_store.nil?
      redirect_to(custom_store_path(current_user.first_store))
    else
      render 'new'
    end
  end

  def create
    @user = current_user
    @store = @user.stores.new(params[:store])

    if @store.save
      flash[:notice] = "#{@store.name} has been created successfully."
      redirect_to custom_store_path(@store)
    else
      render 'new'
    end
  end

  def show
    @store = Store.find(params[:id])
    @is_customized_store = @store.is_slug_in_merchants_with_custom_store_slugs_array?
    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false
    @products = if @current_user_owns_store
                  @store.products.includes([:store,
                                           :instagram_product_images,
                                           :user_product_images])
                else
                  @store.displayable_products
                end.page(params[:page]).per_page(PRODUCT_PAGINATION_SIZE)

    gon.max_pagination_page = @max_pagination_page = @products.total_pages
    gon.store_slug = @store.slug
    gon.store_id = @store.id

    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false

    gon.products_json = products_json = products_json(@products)

    @show_view_more_products_button = show_view_more_products_button?(
                                        @max_pagination_page)

    if @current_user_owns_store && current_user.is_a_new_user? && @store.products.length == 0
      redirect_to(welcome_store_path(@store))
    else
      respond_to do |format|
        format.html
        format.json do
          render :json => {
            :products_json => products_json
          }
        end
      end
    end
  end

  def edit
    @user = current_user
    @store = @user.stores.find(params[:id])
  end

  def update
    @user = current_user
    @store = @user.stores.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "#{@store.name} has been updated successfully."
      redirect_to custom_store_path(@store)
    else
      render 'edit'
    end
  end

  def destroy
    Raise 'You can\'t destroy a store. (Yet.)'
  end

  private

    def redirect_to_current_slug
      @store = begin
          id = params[:id].downcase
          Store.find(id)
        rescue
          nil
      end

      if @store.nil?
        redirect_to root_path
      else
        params[:format] = nil if params[:format] == 'html'
        if request.path != custom_store_path(@store)
          redirect_to custom_store_path(@store, params), :status => :moved_permanently
        end
      end
    end
end
