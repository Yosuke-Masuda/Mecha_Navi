class Company::EmployeesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:index, :show, :edit, :update]
  before_action :ensure_normal_company, only: [:create, :update]

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.company_id = current_company.id if current_company
    if @employee.save
      redirect_to company_employees_path(current_company.id), notice: "社員登録が完了しました。"
    else
      render :new
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to company_employee_path(company_id: current_company.id, id: @employee.id), notice: "社員情報を変更しました"
    else
      render "edit"
    end
  end


  private
    def set_current_company
      if action_name == "index"
        @company = Company.find(params[:company_id])
        @employees = current_company.employees.includes(:store).order("stores.name").page(params[:page]) # 店舗順に社員を管理
        @tasks = @company.tasks
        if current_company.employees != @company.employees
          # 　他企業の場合の処理
          redirect_to root_path, alert: "アクセス権限がありません。"
        end
      else
        @employee = current_company.employees.find_by(id: params[:id])
        if @employee.present? && @employee.company_id == current_company.id
          @employee = Employee.find(params[:id])
        else
          redirect_to company_employees_path(current_company.id), alert: "アクセス権限がありません"
        end
      end
    end

    def ensure_normal_company
      @company = current_company
      if current_company.email == "guest_company@example.com"
        if action_name == "create"
          redirect_to new_company_employee_path(current_company.id), alert: "ゲストユーザーでは権限がありません"  # createアクションの時の遷移先
        elsif action_name == "update"
          @employee = Employee.find(params[:id])
          redirect_to edit_company_employee_path(@company, @employee), alert: "ゲストユーザーでは権限がありません"  # updateアクションの時の遷移先
        end
      end
    end

    def employee_params
      params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana,
                                       :email, :password, :password_confirmation, :is_active, :image, images: [])
    end
end
