class Public::EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end
  
  def create
    @employee = Employee.new(employee_params)
    @employee.company_id = current_company.id if current_company
      if @employee.save
        redirect_to public_index_employees_path(@employee.id), notice: '社員登録が完了しました。'
      else
        render :new
      end
  end
  
  def index
    @employees = current_company.employees.page(params[:page]).per(10)
  end
  
  def show
    @employee = Employee.find_by(id: params[:id])
    if @employee
      @company = @employee.company
    else
      redirect_to employees_path, alert: '指定された社員が存在しません。'
    end
  end
  
  def edit
    @employee = Employee.find(params[:id])
    render "edit"
  end
  
  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to public_index_employees_path(@employee_id), notice: "会員情報を変更しました"
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  def withdraw
    @employee.update(is_active: false)
    reset_session
    redirect_to employee_path
  end

  private

  def employee_params
    params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana, 
                                     :email, :password, :password_confirmation, :is_active, :image, images: [])
  end

end
