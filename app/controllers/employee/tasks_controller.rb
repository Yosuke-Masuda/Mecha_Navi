class Employee::TasksController < ApplicationController


  def index
    @employee = current_employee.company
    @tasks = @employee.tasks
    @daily_tasks = current_employee.daily_tasks.includes(:task).where("tasks.company_id": @employee.id)
    render "employee/tasks/index"
  end


  private

  def task_params
    params.require(:task).permit(:company_id, :name, :body)
  end

end