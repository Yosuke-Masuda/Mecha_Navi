class Admin::StoresController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_store, only: [:show, :edit, :update]


  def index
    @store = Store.new
    @stores = Store.page(params[:page]).order(:name)
    @companies = Company.all
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:notice] = "作成しました"
      redirect_to admin_stores_path
    else
      @stores = Store.page(params[:page]).order(:name)
      @companies = Company.all
      render :index
    end
  end

  def show
    @store = Store.find(params[:id])
    @company = @store.company
    @employees = @store.employees.page(params[:page])
  end

  def edit
    @companies = Company.all
  end

  def update
    if @store.update(store_params)
      flash[:notice] = "編集しました"
      redirect_to admin_stores_path
    else
      render "edit"
    end
  end

  private
    def ensure_store
      @store = Store.find(params[:id])
    end

    def store_params
      params.require(:store).permit(:name, :is_active, :company_id)
    end
end
