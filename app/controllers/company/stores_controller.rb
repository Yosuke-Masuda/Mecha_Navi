class Company::StoresController < ApplicationController
  before_action :authenticate_company!
  def index
    @store = Store.new
    @stores = current_company.stores

  end



  def create
    @store =Store.new(store_params)
    @store.company_id = current_company.id
    if @store.save
      flash[:notice] = "作成しました"
      redirect_to stores_path
    else
      flash[:alert] = "作成に失敗しました"
      @stores = current_company.stores
      render :index
    end

  end

  def show
    @store = Store.find(params[:id])
    @employees = @store.employees
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(store_params)
      flash[:notice] = "編集しました"
      redirect_to stores_path
    else
      flash[:alert] = "編集に失敗しました"
      render "edit"
    end

  end

  private
   def store_params
    params.require(:store).permit(:name, :company_id, :is_active)
   end

end
