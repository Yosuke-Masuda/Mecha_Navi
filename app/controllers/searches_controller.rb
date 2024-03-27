class SearchesController < ApplicationController
  
  
  before_action :authenticate_employee!

  def search
    @range = params[:range]

    if @range == "Employee"
      @employees = Employee.looks(params[:search], params[:word])
    else
      @posts = Post.looks(params[:search], params[:word])
    end
  end
end
