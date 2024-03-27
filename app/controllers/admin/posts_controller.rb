class Admin::PostsController < ApplicationController
   def index
    @company = Company.find(params[:company_id])
    @recent_posts = @company.posts.group(:employee_id).order(created_at: :desc)
    @all_posts_count = @company.posts.count
   end
end
