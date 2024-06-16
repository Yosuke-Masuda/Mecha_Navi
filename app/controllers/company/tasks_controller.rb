class Company::TasksController < ApplicationController


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

  def confirm
    @company = Company.find(params[:company_id])
    @tasks = @company.tasks
  end

  def show
    @company = current_company
    @employee = Employee.find(params[:employee_id])
    ##@tasks = @employee.tasks

    @tasks = @company.tasks
    @daily_tasks = @employee.daily_tasks.includes(:task).where("tasks.company_id": @company.id)
  end

  def edit
    @task = Task.find(params[:id])
    @company = Company.find(params[:company_id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to company_tasks_path(company_id: current_company.id), notice: "タスクを更新しました"
    else
      render "edit"
    end

  end


  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to company_tasks_path(company_id: current_company.id, id: @task.id), notice: "タスクを削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:company_id, :name, :body, :start_time)
  end
end
