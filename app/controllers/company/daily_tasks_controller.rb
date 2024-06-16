class Company::DailyTasksController < ApplicationController
  before_action :set_current_company

  def index
    @company = current_company
    @employee = current_company.employees.find_by(id: params[:employee_id]) # パラメータから選択された社員を取得する
    @tasks = @company.tasks
    @day = Time.zone.parse("#{params[:date]} 00:00:00")
    @daily_tasks = @tasks.map { |task| task.daily_tasks.find_or_initialize_by(employee_id: @employee.id, start_time: @day) }
  end


  private

  def set_current_company
    @company = current_company # ログインしている社員を取得する処理を実装する
  end
end
