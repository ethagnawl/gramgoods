class ProductsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!, :except => [:show]
  before_filter :except => [:show, :destroy] do |controller|
    # why won't this work for :destroy?
    controller.instance_eval do
      if store = Store.find((params[:store_id] || params[:product][:store_id]))
        redirect_to(root_path) unless user_owns_store?(store.id)
      else
        redirect_to(root_path)
      end
    end
  end

  respond_to :html, :json

  # redirect old urls to new urls
  #if request.path != store_path(@store)
  #  redirect_to(@store, :status => :moved_permanently)
  #end

  def index
    @store = Store.find(params[:store_id])
    respond_to do |format|
      format.json {
        render :json => @store.products.reverse.map { |product|
          render_product_widget_template(@store, product) }
      }
      format.html { redirect_to(store_path(Store.find(params[:store_id]))) }
    end

  end

  def new
    @user = current_user
    @product = Product.new
    @store = Store.find(params[:store_id])
  end

  def create
    @product = Product.new(params[:product])
    @store = Store.find(params[:product][:store_id])
    product_photos_is_empty = true if defined?(params[:product][:photos]) == false # <- this is criminal!
    product_photos_is_empty = !params[:product][:photos].nil? && params[:product][:photos].empty?
    @product.status = 'Draft' if product_photos_is_empty
    if @product.save
      if product_photos_is_empty
        @product[:alert] = product_photos_empty_message(@product.name)
        flash[:alert] = product_photos_empty_message(@product.name)
      end
      respond_with(@product, :location => store_product_path(@store, @product))
    else
      respond_to do |format|
        format.json {
          render :json => {
            :status => 'error'
          }.merge({ :errors => @product.errors.full_messages.map { |message| { :error => message }}})
        }
        format.html { render 'new' }
      end
    end
  end

  def show
    @product = Product.find(params[:id])
    @store = Store.find(params[:store_id])
    @user = User.find(Integer(@store.user_id))
    respond_to do |format|
      format.json {
        render :json => render_product_widget_template(@store, @product)
      }
      format.html { render_conditional_layout(params[:layout]) }
    end
  end

  def edit
    @user = current_user
    @product = Product.find(params[:id])
    @store = Store.find(params[:store_id])
  end

  def update
    @product = Product.find(params[:id])
    @store = Store.find(params[:product][:store_id])
    product_photos_is_empty = true if defined?(params[:product][:photos]) == false # <- this is criminal!
    product_photos_is_empty = !params[:product][:photos].nil? && params[:product][:photos].empty?
    params[:product][:status] = 'Draft' if product_photos_is_empty
    if @product.update_attributes(params[:product])
      if product_photos_is_empty
        flash[:alert] = product_photos_empty_message(@product.name)
      end
      respond_to do |format|
        format.json {
          render :json => @product
        }
        format.html { redirect_to(store_product_path(@store, @product)) }
      end
    else
      respond_to do |format|
        format.json {
          render :json => @product.errors
        }
        format.html { render 'edit' }
      end
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
    "You will need to attach at least one image to '#{name}' before setting Status to Active."
  end
end
