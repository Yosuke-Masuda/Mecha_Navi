class Admin::EmployeesController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @employees = @company.employees
    @stores = Store.all
  end

  def show
    @company = Company.find(params[:company_id])
    @employee = @company.employees.includes(:store).find(params[:id]) # 追加
  end



  def edit
    @employee = Employee.find(params[:id])
    @stores = @employee.company.stores
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to admin_company_employee_path(id: @employee.id, company_id: @employee.company_id), notice: "会員情報を変更しました"
    else
      @stores = @employee.company.stores
      render "edit"
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:company_id, :employee_id, :store_id, :image, :last_name, :first_name, :last_name_kana, :first_name_kana, :email, :is_active)
  end


end
