class Company::CarNamesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:index, :edit, :update]
  before_action :ensure_normal_company, only: :update

  def index
  end

  def create
    @car_name =CarName.new(car_name_params)
    @car_name.company_id = current_company.id
    if @car_name.save
      flash[:notice] = "作成しました"
      redirect_to company_car_names_path(current_company.id)
    else
      @car_names = current_company.car_names
      render :index
    end
  end

  def edit
  end

  def update
    if @car_name.update(car_name_params)
      flash[:notice] = "編集しました"
      redirect_to company_car_names_path(current_company.id)
    else
      render "edit"
    end
  end

  private

  def set_current_company
    if params[:action].in?(%w[index])
      @company = Company.find(params[:company_id])
      @car_name = CarName.new
      @car_names = current_company.car_names.page(params[:page])
      redirect_to root_path, alert: 'アクセス権限がありません' unless current_company == @company
    else
      @car_name = current_company.car_names.find_by(id: params[:id])
      if @car_name.present? && @car_name.company_id == current_company.id
        @car_name = CarName.find(params[:id])
      else
        redirect_to company_car_names_path(current_company.id), alert: 'アクセス権限がありません'
      end
    end
  end

  def ensure_normal_company
    @car_name = CarName.find(params[:id])
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_car_name_path(current_company.id, @car_name), alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def car_name_params
    params.require(:car_name).permit(:name, :car_type, :company_id, :is_active)
  end

end