class Employee::DailyTasksController < ApplicationController
  before_action :set_current_employee

  def new
    @company = current_employee.company
    @employee = Employee.find(params[:employee_id])
    @tasks = @company.tasks
    @day = Time.zone.parse("#{params[:date]} 00:00:00")
    @daily_tasks = @tasks.map { |task| current_employee.daily_tasks.find_or_initialize_by(task_id: task.id, start_time: @day) }
  end

  def create
    daily_task = current_employee.daily_tasks.build(daily_task_params)
    daily_task.completed = true
    daily_task.save!

    @company = daily_task.task.company
    @tasks = @company.tasks
    @day = daily_task.start_time

    @daily_tasks = @tasks.map { |task| current_employee.daily_tasks.find_or_initialize_by(task_id: task.id, start_time: @day) }

    redirect_back(fallback_location: root_url)
  end

  private

  def set_current_employee
    @current_employee = current_employee # ログインしている社員を取得する処理を実装する
  end

  def daily_task_params
    params.require(:daily_task).permit(:employee_id, :task_id, :start_time)
  end
end
