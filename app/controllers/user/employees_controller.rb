class User::EmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_current_employee, only: [:show, :edit, :update, :unsubscribe, :withdraw]
  def new
    @employee = Employee.new
    @genres = current_employee.company.genres
  end
  def create
  @employee = Employee.new(employee_params)
  @employee.company_id = current_company.id if current_company
    if @employee.save
      redirect_to root_path, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end
  
  def show
    @employee = current_employee
    @company = @employee.company
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to mypage_path, notice: '会員情報の更新が完了しました。'
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @employee.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  private

  def set_current_employee
    @employee = current_employee
  end

  def employee_params
    params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana, :email, :password, :password_confirmation, :is_active)
  end

end