class SearchesController < ApplicationController

  def search
    @range = params[:range]

    if @range == "社員"
      @employees = Employee.looks(params[:search], params[:word])
    else
      @posts = Post.looks("partial_match", params[:word])
    end
  end

end
