class Company::HomesController < ApplicationController
  before_action :authenticate_company!

  def top
    @company = current_company
    @recent_posts = Post.where(company_id: @company.id).group(:employee_id).order(created_at: :desc).page(params[:page]).per(10)
    @all_posts_count_by_employee = @company.posts.group(:employee_id).count #社員１人が投稿した全件数
    @favorites_count_by_employee = Post.joins(:favorites).where(company_id: @company.id).group(:employee_id).count
  end

end
