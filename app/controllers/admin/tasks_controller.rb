class Admin::TasksController < ApplicationController
  before_action :authenticate_admin!


  def index
    @task = Task.new
    @tasks = Task.all
    @companies = Company.all

  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "作成しました"
      redirect_to admin_tasks_path
    else
      @tasks = Task.all
      @companies = Company.all
      render :index
    end

  end

  def show
    @company = Company.find(params[:company_id])
    @employee = Employee.find(params[:employee_id])
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

  private
   def task_params
    params.require(:task).permit(:company_id, :employee_id, :task_id, :name, :body, :start_time)
   end
end
