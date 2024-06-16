class Admin::DailyTasksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @company = Company.find(params[:company_id])
    @employee = @company.employees.find_by(id: params[:employee_id]) # パラメータから選択された社員を取得する
    @tasks = @company.tasks
    @day = Time.zone.parse("#{params[:date]} 00:00:00")
    @daily_tasks = @tasks.map { |task| task.daily_tasks.find_or_initialize_by(employee_id: @employee.id, start_time: @day) }
  end

end
