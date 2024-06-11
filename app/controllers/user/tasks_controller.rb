class User::TasksController < ApplicationController


  def index
    @employee = current_employee.company
    @tasks = @employee.tasks
    @daily_tasks = current_employee.daily_tasks.includes(:task).where("tasks.company_id": @employee.id)
    render "user/tasks/index"
  end


  private

  def task_params
    params.require(:task).permit(:company_id, :employee_id, :name, :body, :memo, :scheduled_date, :start_time, :is_holiday, :checked, :status)  # 許可するパラメータを指定
  end

end