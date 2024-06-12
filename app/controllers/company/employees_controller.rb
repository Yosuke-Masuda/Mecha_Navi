class Company::EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.company_id = current_company.id if current_company
      if @employee.save
        redirect_to company_employees_path(@employee.id), notice: '社員登録が完了しました。'
      else
        render :new
      end
  end

  def index
    @employees = current_company.employees.includes(:store).order('stores.name').page(params[:page]).per(10)#店舗順に社員を管理
    @company = current_company
    @tasks = @company.tasks
  end

  def show
    @employee = current_company.employees
    if @employee
      redirect_to company_employees_path(company_id: current_company.id), alert: '指定された社員が存在しません。'
    else
      @employee = Employee.find(params[:id])
    end
  end

  def edit
    @employee = Employee.find(params[:id])
    render "edit"
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to company_employee_path(company_id: current_company.id, id: @employee.id), notice: "社員情報を変更しました"
    else
      render "edit"
    end
  end


  private

  def employee_params
    params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana,
                                     :email, :password, :password_confirmation, :is_active, :image, images: [])
  end

end
