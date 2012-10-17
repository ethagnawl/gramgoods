class StoresController < ApplicationController
  layout 'admin'
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
    render_conditional_layout(params[:layout])
  end

  def proxy
    @user = User.new params[:user]
    @store = Store.new params[:store]
    instagram_auth_url_with_params = "#{INSTAGRAM_CONFIG['AUTH_URL']}?" << params.to_query

    if @user.valid? && @store.valid?
      redirect_to instagram_auth_url_with_params
    else
      render 'new.mobile', :layout => 'mobile'
    end
  end

  def new
    @user = User.new

    if !current_user.nil? && !current_user.first_store.nil?
      redirect_to(custom_store_path(current_user.first_store))
    else
      @store = Store.new
      if mobile_device? or params[:layout] == 'mobile'
        render 'new.mobile', :layout => 'mobile'
      end
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

    redirect_to_current_slug

    @products = @store.products.includes([:store, :product_images, :instagram_tag])
    gon.store_slug = @store.slug
    gon.store_id = @store.id
    gon.product_widgets = @products.map do |product|
      render_product_widget_template(@store, product)
    end
    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false
    if @current_user_owns_store
      if params[:layout] == 'mobile'
        render 'stores/show.mobile', :layout => 'mobile'
      elsif mobile_device?
        @products = @store.products
        render 'stores/show.mobile', :layout => 'mobile'
      else
        @product = @store.products.new
        render :layout => 'admin'
      end
    else
      @products = @store.displayable_products
      render 'stores/show.mobile', :layout => 'mobile'
    end
  end

  def edit
    @user = current_user
    @store = @user.stores.find(params[:id])
    if mobile_device? or params[:layout] == 'mobile'
      render 'edit.mobile', :layout => 'mobile'
    end
  end

  def update
    @user = current_user
    @store = @user.stores.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "#{@store.name} has been updated successfully."
      redirect_to custom_store_path(@store)
    else
      if mobile_device? or params[:layout] == 'mobile'
        render 'edit.mobile', :layout => 'mobile'
      else
        render 'edit'
      end
    end
  end

  def destroy
    Raise 'You can\'t destroy a store. (Yet.)'
  end

  private

    def redirect_to_current_slug
      @store = Store.find(params[:id])
      if request.path != custom_store_path(@store)
        redirect_to custom_store_path(@store), status: :moved_permanently
      end
    end
end
