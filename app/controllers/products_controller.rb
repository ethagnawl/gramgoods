class ProductsController < ApplicationController
  layout 'admin'
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

  respond_to :html, :json

  # redirect old urls to new urls
  #if request.path != store_path(@store)
  #  redirect_to(@store, :status => :moved_permanently)
  #end

  def index
    respond_to do |format|
      format.json {
        @store = Store.find(params[:store_id])
        render :json => @store.products.includes([:product_images, :instagram_tag]).map { |product|
          render_product_widget_template(@store, product) }
      }
      format.html {
        @products = Product.order('created_at DESC').limit(10)
                      .where(:status => 'Active')
        render 'products/index.mobile', :layout => 'mobile'
      }
    end
  end

  def new
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new({
                                     :instagram_tag => InstagramTag.new,
                                     :colors => [Color.new],
                                     :sizes => [Size.new]})
    if mobile_device?
      render 'products/new.mobile', :layout => 'mobile'
    end
  end

  def create
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.new(params[:product])
    product_images = params[:product][:product_images_attributes]
    product_photos_is_empty = !product_images.nil? && product_images.length != 0 ? false : true
    @product.status = 'Draft' if product_photos_is_empty
    @product.status = 'Out of Stock' if @product.quantity.to_i == 0 && @product.unlimited_quantity == 0
    if @product.save
      if product_photos_is_empty
        flash[:alert] = product_photos_empty_message(@product.name)
      end
      respond_to do |format|
        format.json {
          render :json => {
            :product => @product,
            :alert => (product_photos_is_empty ? product_photos_empty_message(@product.name) : nil)
          }
        }
        format.html {
          redirect_to(store_product_path(@store, @product))
        }
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            :status => 'error',
            :errors => @product.errors.full_messages.map do |message|
              { :error => message }
            end
          }
        }
        format.html { render 'new' }
      end
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

    respond_to do |format|
      format.json {
        render 'products/show'
      }
      format.html {
        if @product.status == 'Draft' && !user_signed_in?
          redirect_to("/#{@store.slug}")
        else
          render 'products/show.mobile', :layout => 'mobile'
        end
      }
    end
  end

  def edit
    @user = current_user
    @store = @user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
    if mobile_device?
      render 'products/edit.mobile', :layout => 'mobile'
    end
  end

  def update
    @store = current_user.stores.find(params[:store_id])
    @product = @store.products.find(params[:id])
    if @product.update_attributes(params[:product])
      respond_to do |format|
        format.json {
          render :json => {
            :product => @product
          }
        }
        format.html { redirect_to(store_product_path(@store, @product)) }
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            :status => 'error',
            :errors => @product.errors.full_messages.map do |message|
              { :error => message }
            end
          }
        }
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @store = Store.find(params[:store_slug])
    @product = @store.products.find(params[:product_slug])

    if user_owns_store?(@store.id)
      @product.destroy
      notice = "#{@product.name} has been successfully deleted."
      flash[:notice] = notice
      respond_to do |format|
        format.json {
          render :json => {
            :status => 'success',
            :notice => notice
          }
        }
        format.html {
          redirect_to(store_path(@store))
        }
      end
    else
      redirect_to(root_path)
    end
  end

  private

  def product_photos_empty_message(name)
    "You will need to attach at least one image to '#{name}' before setting Status to Active."
  end
end
