class Admin::TasksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @task = Task.new
    @tasks = Task.page(params[:page])
    @companies = Company.all

  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "作成しました"
      redirect_to admin_tasks_path
    else
      @tasks = Task.page(params[:page])
      @companies = Company.all
      render :index
    end
  end

  def calendar
    @company = Company.find(params[:company_id])
    @employee = @company.employees.find_by(id: params[:employee_id]) # パラメータから選択された社員を取得する
    @tasks = @company.tasks
    @daily_tasks = @employee.daily_tasks.includes(:task).where("tasks.company_id": @company.id)
  end

  def edit
    @task = Task.find(params[:id])
    @companies = Company.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = "編集しました"
      redirect_to admin_tasks_path
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to admin_tasks_path, notice: "タスクを削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:company_id, :employee_id, :task_id, :name, :body, :start_time)
  end

end
