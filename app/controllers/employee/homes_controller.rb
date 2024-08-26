class Employee::HomesController < ApplicationController
  before_action :authenticate_employee!, except: [:top, :about]

  def top
    if current_employee
      @company = current_employee.company
      @posts = current_employee.company.posts.page(params[:page]).order(created_at: :desc).limit(5)
    end
  end
end
