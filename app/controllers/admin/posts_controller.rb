class Admin::PostsController < ApplicationController
   def index
     @company = Company.find(params[:company_id])
     @recent_posts = Post.where(company_id: @company.id).group(:employee_id).order(created_at: :desc)
     @all_posts_count_by_employee = @company.posts.group(:employee_id).count
     @favorites_count_by_employee = Post.joins(:favorites).where(company_id: @company.id).group(:employee_id).count
   end

   def history
     @employee = Employee.find(params[:employee_id])
     @posts = @employee.posts
     @images = @posts.map { |post| post.images }.flatten.uniq
     @video = @posts.first.video #動画の表示

   end

   def show

   end
end
