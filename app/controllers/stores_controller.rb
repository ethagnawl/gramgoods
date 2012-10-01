class StoresController < ApplicationController
  layout 'admin'
  #before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :authenticate_user!, :except => [:show]
  before_filter :except => [:create, :new, :show, :index, :destroy] do |controller|
    # why won't this work for :destroy?
    controller.instance_eval do
      if store = Store.find(params[:id])
        redirect_to(store_path(store)) unless user_owns_store?(store.id)
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

  def new
    @user = current_user
    @store = @user.stores.new
  end

  def create
    @user = current_user
    @store = @user.stores.new(params[:store])
    if @store.save
      flash[:notice] = "#{@store.name} has been created successfully."
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def show
    @store = Store.find(params[:id])
    @products = @store.products.includes([:product_images, :instagram_tag])
    gon.store_slug = @store.slug
    gon.store_id = @store.id
    gon.product_widgets = @products.map do |product|
      render_product_widget_template(@store, product)
    end
    @current_user_owns_store = user_signed_in? ? user_owns_store?(@store.id) : false
    if @current_user_owns_store
      if params[:layout] == 'mobile'
        @products = @store.displayable_products
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
  end

  def update
    @user = current_user
    @store = @user.stores.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "#{@store.name} has been updated successfully."
      redirect_to(@store)
    else
      render 'edit'
    end
  end

  def destroy
    Raise 'You can\'t destroy a store. (Yet.)'
  end
end
