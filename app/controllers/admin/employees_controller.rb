class Admin::EmployeesController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @employees = @company.employees
  end

  def show
    @company = Company.find(params[:company_id])
    @employee = @company.employees.find(params[:id])
  end

end
