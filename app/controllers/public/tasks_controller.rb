class Public::TasksController < ApplicationController
  
  def index
    @task = Task.new
    @tasks = current_company.tasks
  end
  
  def create
    @task = Task.new(task_params)
    @task.company_id = current_company.id
    if @task.save
      redirect_to public_tasks_companies_path(@company), notice: "タスクを作成しました"
    else
      @tasks = current_company.tasks  
      render :index
    end

  end
  
  def edit
    @task = Task.find(params[:id])
    @company = current_company
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to public_tasks_companies_path(@company), notice: "タスクを更新しました"
    else
      render "edit"
    end

  end
  

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to public_tasks_companies_path(@company), notice: "タスクを削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:name, :body, :memo, :scheduled_date, :checked)
  end
end
