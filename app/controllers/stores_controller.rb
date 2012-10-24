class StoresController < ApplicationController
  layout 'mobile'
  before_filter :redirect_to_current_slug, :only => :show
  before_filter :authenticate_user!, :except => [:show, :new, :proxy]
  before_filter :except => [:proxy, :create, :new, :show, :index, :destroy] do |controller|
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

    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false
    @products = if @current_user_owns_store
                  @store.products.includes([:store, :instagram_tag])
                else
                  @store.displayable_products
                end.page(params[:page]).per_page(5)
    gon.store_slug = @store.slug
    gon.store_id = @store.id
    gon.product_widgets = @products.map do |product|
      render_product_widget_template(@store, product)
    end
    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false
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
          Store.find(params[:id])
        rescue
          nil
      end

      if @store.nil?
        redirect_to root_path
      else
        if request.path != custom_store_path(@store)
          redirect_to custom_store_path(@store, params), :status => :moved_permanently
        end
      end
    end
end
