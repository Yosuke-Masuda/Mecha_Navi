class Company::TasksController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:edit, :update, :destroy]
  before_action :ensure_normal_company, only: [:update, :destroy]


  def index
    @company = Company.find(params[:company_id])
    @tasks = @company.tasks
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.company_id = current_company.id
    if @task.save
      redirect_to company_tasks_path(company_id: current_company.id), notice: "タスクを作成しました"
    else
      @tasks = current_company.tasks
      render :index
    end

  end

  def calendar
    @company = current_company
    @employee = Employee.find(params[:employee_id])
    @tasks = @company.tasks
    @daily_tasks = @employee.daily_tasks.includes(:task).where("tasks.company_id": @company.id)
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to company_tasks_path(company_id: current_company.id), notice: "タスクを更新しました"
    else
      render "edit"
    end

  end


  def destroy
    @task.destroy
    redirect_to company_tasks_path(company_id: current_company.id, id: @task.id), notice: "タスクを削除しました。"
  end

  private

  def set_current_company
    @task = current_company.tasks.find_by(id: params[:id])
    if @task.present? && @task.company_id == current_company.id
      @task = Task.find(params[:id])
    else
      redirect_to company_tasks_path(current_company.id), alert: 'アクセス権限がありません'
    end
  end

  def ensure_normal_company
    @task = Task.find(params[:id])
    @company = Company.find(params[:company_id])
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_task_path(@company, @task), alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def task_params
    params.require(:task).permit(:company_id, :name, :body)
  end
end
