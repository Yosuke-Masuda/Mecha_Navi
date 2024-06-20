class SearchesController < ApplicationController

  def search
    if admin_signed_in?
      @posts = Post.all
    elsif company_signed_in?
      @posts = current_company.posts
    elsif employee_signed_in?
      @posts = current_employee.company.posts
    end
      
    @posts = @posts.looks(params[:genre_id], params[:word])
  end
end
