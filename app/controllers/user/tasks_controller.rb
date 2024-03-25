class User::TasksController < ApplicationController

  def new
    @tasks = current_employee.company.tasks
    @task = Task.new
  end

  def index
    @company = current_employee.company
    @tasks = @company.tasks
    @daily_tasks = current_employee.daily_tasks.includes(:task).where("tasks.company_id": @company.id)
    render "user/tasks/index"
  end



  def confirm
    @tasks = current_employee.company.tasks
    @task = Task.new(task_params)
  end

  def complete

  end


  private

  def task_params
    params.require(:task).permit(:company_id, :employee_id, :name, :body, :memo, :scheduled_date, :start_time, :is_holiday, :checked, :status)  # 許可するパラメータを指定
  end

end