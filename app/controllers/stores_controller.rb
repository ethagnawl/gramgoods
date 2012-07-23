class StoresController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :except => [:show, :index, :destroy] do |controller|
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
    @store.user_id = @user
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
    @store = Store.find(params[:id])
    render_conditional_layout(params[:layout])
  end

  def edit
    @store = Store.find(params[:id])
  end

  def destroy
    Raise 'You can\'t destroy a store. (Yet.)'
  end
end
