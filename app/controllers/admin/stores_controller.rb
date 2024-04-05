class Admin::StoresController < ApplicationController
  before_action :authenticate_admin!


  def index
    @store = Store.new
    @stores = Store.all
    @companies = Company.all
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:notice] = "作成しました"
      redirect_to admin_stores_path
    else
      @stores = Store.all
      @companies = Company.all
      render :index
    end

  end

  def edit
    @store = Store.find(params[:id])
    @companies = Company.all
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(store_params)
      flash[:notice] = "編集しました"
      redirect_to admin_stores_path
    else
      render "edit"
    end

  end

  private
   def store_params
    params.require(:store).permit(:name, :is_active, :company_id)
   end

end
