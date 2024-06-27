class Employee::EmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_current_employee, only: [:show, :edit, :update]
  before_action :ensure_normal_employee, only: :update

  def index
    @employee = current_employee.company
    @employees = @employee.stores.flat_map(&:employees)
    @employees = Kaminari.paginate_array(@employees).page(params[:page])
  end

  def show
  end

  def history
    @posts = Post.where(employee_id: current_employee.id).order(created_at: :desc).page(params[:page])
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

  def favorites
    favorites= Favorite.where(employee_id: current_employee.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorites).page(params[:page])
  end

  private

  def set_current_employee
    @employee = current_employee
  end

  def ensure_normal_employee
    @employee = current_employee
    if current_employee.email == 'guest_employee@example.com'
      redirect_to edit_mypage_path, alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def employee_params
    params.require(:employee).permit(:company_id, :store_id, :last_name, :first_name, :first_name_kana, :last_name_kana, :image)
  end

end
