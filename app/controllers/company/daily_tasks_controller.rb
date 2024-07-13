class Company::DailyTasksController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: :index

  def index
  end


  private

  def set_current_company
    if action_name == "index"
      @company = Company.find(params[:company_id])
      @employee = current_company.employees.find_by(id: params[:employee_id]) # パラメータから選択された社員を取得する
      @tasks = @company.tasks
      @day = Time.zone.parse("#{params[:date]} 00:00:00")
      @daily_tasks = @tasks.map { |task| task.daily_tasks.find_or_initialize_by(employee_id: @employee.id, start_time: @day) }
      if current_company.employees != @company.employees
        redirect_to root_path, alert: 'アクセス権限がありません'
      end
    end
  end

end
