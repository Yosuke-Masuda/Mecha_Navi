class Public::CarNamesController < ApplicationController
  before_action :authenticate_company!
  def index
    @car_name = CarName.new
    @car_names = current_company.car_names

  end
  
  
  
  def create
    @car_name =CarName.new(car_name_params)
    @car_name.company_id = current_company.id
    if @car_name.save
      flash[:notice] = "作成しました"
      redirect_to car_names_path
    else
      @car_names = current_company.car_names
      flash[:alert] = "作成に失敗しました"
      render :index
    end

  end

  def edit
    @car_name = CarName.find(params[:id])
  end

  def update
    @car_name = CarName.find(params[:id])
    if @car_name.update(car_name_params)
      flash[:notice] = "編集しました"
      redirect_to car_names_path
    else
      flash[:alert] = "編集に失敗しました"
      render "edit"
    end

  end

  private
   def car_name_params
    params.require(:car_name).permit(:name, :car_type, :company_id, :is_active)
   end

end