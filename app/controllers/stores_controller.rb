class StoresController < ApplicationController
  def index
    @user = current_user
  end

  def new
    @user = current_user.id
    @store = Store.new
    @store.user_id = @user
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def show
    @store = Store.find(params[:id])
  end
end
