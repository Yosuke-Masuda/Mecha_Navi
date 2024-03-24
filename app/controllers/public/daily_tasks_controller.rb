class Public::DailyTasksController < ApplicationController
  def new
    @company = Company.find(params[:company_id])
    @tasks = @company.tasks
    @day = Time.zone.parse("#{params[:date]} 00:00:00")
    
    @daily_tasks = @tasks.map { |task| current_employee.daily_tasks.find_or_initialize_by(task_id: task.id, start_time: @day) }
  end
  
  def create
    daily_task = current_employee.daily_tasks.build(daily_task_params)
    daily_task.save!
    
    @company = daily_task.task.company
    @tasks = @company.tasks
    @day = daily_task.start_time
    
    @daily_tasks = @tasks.map { |task| current_employee.daily_tasks.find_or_initialize_by(task_id: task.id, start_time: @day) }
    
    redirect_back(fallback_location: root_url)
  end
  
  private
  
  def daily_task_params
    params.require(:daily_task).permit(:task_id, :start_time)
  end
end
