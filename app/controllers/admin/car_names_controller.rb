class Admin::CarNamesController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_car_name, only: [:edit, :update]

  def index
    @car_name = CarName.new
    @car_names = CarName.page(params[:page]).order(:name)
    @companies = Company.all
  end

  def create
    @car_name = CarName.new(car_name_params)
    if @car_name.save
      flash[:notice] = "作成しました"
      redirect_to admin_car_names_path
    else
      @car_names = CarName.page(params[:page]).order(:name)
      @companies = Company.all
      render :index
    end

  end

  def edit
  end

  def update
    if @car_name.update(car_name_params)
      flash[:notice] = "編集しました"
      redirect_to admin_car_names_path
    else
      render "edit"
    end

  end

  private

  def ensure_car_name
    @car_name = CarName.find(params[:id])
    @companies = Company.all
  end

  def car_name_params
    params.require(:car_name).permit(:name, :car_type, :is_active, :company_id)
  end
end
