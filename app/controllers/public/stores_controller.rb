class Public::StoresController < ApplicationController
  before_action :authenticate_company!
  def index
    @store = Store.new
    @stores = current_company.stores

  end
  
  
  
  def create
    @store =Store.new(store_params)
    @store.company_id = current_company.id
    if @store.save
      redirect_to stores_path
    else
      @stores = current_company.stores  
      render :index
    end

  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(store_params)
      redirect_to stores_path
    else
      render "edit"
    end

  end

  private
   def store_params
    params.require(:store).permit(:name, :company_id, :is_active)
   end

end
