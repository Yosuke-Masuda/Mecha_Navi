class Company::StoresController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:show, :edit, :update]
  before_action :ensure_normal_company, only: :update

  def index
    @company = current_company
    @stores = @company.stores
    @store = Store.new
  end



  def create
    @store =Store.new(store_params)
    @store.company_id = current_company.id
    if @store.save
      flash[:notice] = "作成しました"
      redirect_to company_stores_path(current_company.id)
    else
      @stores = current_company.stores
      render :index
    end

  end

  def show
  end

  def edit

  end

  def update
    if @store.update(store_params)
      flash[:notice] = "編集しました"
      redirect_to company_stores_path(current_company.id)
    else
      render "edit"
    end

  end

  private


  def set_current_company
    @store = current_company.stores.find_by(id: params[:id])
    if @store.present? && @store.company_id == current_company.id
      @store = Store.find(params[:id])
    else
      redirect_to company_stores_path(current_company.id), alert: 'アクセス権限がありません'
    end
  end

  def ensure_normal_company
    @store = Store.find(params[:id])
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_store_path(current_comapny.id, @store), alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def store_params
    params.require(:store).permit(:name, :company_id, :is_active)
  end

end
