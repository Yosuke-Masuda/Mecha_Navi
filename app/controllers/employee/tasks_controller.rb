class Employee::TasksController < ApplicationController
  before_action :authenticate_employee!

  def index
    @employee = current_employee.company
    @tasks = @employee.tasks
    @daily_tasks = current_employee.daily_tasks.includes(:task).where("tasks.company_id": @employee.id)
  end

  private

  def task_params
    params.require(:task).permit(:company_id, :name, :body)
  end

end