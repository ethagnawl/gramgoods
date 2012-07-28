class StoresController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :except => [:create, :new, :show, :index, :destroy] do |controller|
    # why won't this work for :destroy?
    controller.instance_eval do
      if store = Store.find(params[:id])
        redirect_to(root_path) unless user_owns_store?(store.id)
      else
        redirect_to(root_path)
      end
    end
  end

  def index
    @user = current_user
    @stores = Store.find_all_by_user_id(current_user)
    render_conditional_layout(params[:layout])
  end

  def new
    @store = Store.new
    @user = current_user
  end

  def create
    @store = Store.new(params[:store])
    @store[:user_id] = current_user.id
    if @store.save
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @store = Store.find(params[:id])
    gon.store_slug = @store.slug
    gon.store_id = @store.id
    @product = Product.new
    gon.product_widgets = @store.products.map do |product|
      render_product_widget_template(@store, product)
    end
    render_conditional_layout(params[:layout])
  end

  def edit
    @user = current_user
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "#{@store.name} was successfully updated."
      redirect_to(@store)
    else
      render 'edit', :layout => 'admin'
    end
  end

  def destroy
    Raise 'You can\'t destroy a store. (Yet.)'
  end
end
