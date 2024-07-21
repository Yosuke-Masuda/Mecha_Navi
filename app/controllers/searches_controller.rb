class SearchesController < ApplicationController

  def search
    if admin_signed_in?
      @posts = Post.page(params[:page]).order(created_at: :desc)
    elsif company_signed_in?
      @posts = current_company.posts.page(params[:page]).order(created_at: :desc)
    else employee_signed_in?
      @posts = current_employee.company.posts.page(params[:page]).order(created_at: :desc)
    end

    @posts = @posts.looks(params[:genre_id], params[:word])
  end
end
