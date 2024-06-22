class Employee::EmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_current_employee, only: [:show, :history, :edit, :update, :favorites]
  before_action :ensure_normal_employee, only: :update

  def ensure_normal_employee
    @company = current_employee.company
    @employee = current_employee
    if current_employee.email == 'guest_employee@example.com'
      redirect_to edit_mypage_path, alert: 'ゲストユーザーでは権限がありません'
    end
  end


  def show
   @company = current_employee.company
  end

  def history
    @my_posts = Post.where(employee_id: current_employee.id).order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    @company = current_employee.company
    @employee = current_employee
    render "edit"
  end

  def update
    @employee = current_employee
    if @employee.update!(employee_params)
      redirect_to mypage_path, notice: '会員情報の更新が完了しました。'
    else
      render :edit
    end
  end



  def favorites
    @employee = Employee.find(params[:id])
    favorites= Favorite.where(employee_id: @employee.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private

  def set_current_employee
    @employee = current_employee
  end

  def employee_params
    params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana, :email, :password, :password_confirmation, :is_active, :image, images: [])
  end

end
