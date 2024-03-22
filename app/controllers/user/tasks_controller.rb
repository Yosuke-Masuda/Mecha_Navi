class User::TasksController < ApplicationController
  def index
    @tasks = current_employee.company.tasks
  end

  def complete
    @tasks = current_employee.company.tasks.find(params[:task_id])
    @tasks.update(completed: true)
    redirect_to employee_tasks_complete_path, notice: "タスクを完了しました。"
  end

end