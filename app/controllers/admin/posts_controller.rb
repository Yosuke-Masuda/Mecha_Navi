class Admin::PostsController < ApplicationController
   def index
     @company = Company.find(params[:company_id])
     @recent_posts = Post.where(company_id: @company.id).group(:employee_id).order(created_at: :desc) #最近の投稿
     @all_posts_count_by_employee = @company.posts.group(:employee_id).count #社員１人が投稿した全件数
     @favorites_count_by_employee = Post.joins(:favorites).where(company_id: @company.id).group(:employee_id).count #いいねされた全件数
   end

   def history
     @company = Company.find(params[:company_id])
     @employee = Employee.find(params[:employee_id])
     @posts = @employee.posts
     @images = @posts.map { |post| post.images }.flatten.uniq
     @video = @posts.first.video #動画の表示

   end

   def show
     @post = Post.find(params[:id]) # @postを定義する
     @employee = @post.employee # @employeeを@postから取得する
     @posts = @employee.posts
     @images = @post.images.map(&:blob).uniq
     @video = @post.video
   end

   def edit

   end

   def destroy
     @post = Post.find(params[:id])

     if @post.destroy
       redirect_to admin_company_employee_posts_path(@post.employee.company, @post.employee), notice: '投稿を削除しました。'
     else
       redirect_to admin_company_employee_posts_path(@post.employee.company, @post.employee), alert: '投稿の削除に失敗しました。'
     end
   end

   private

   def post_params
     params.require(:post).permit(:employee_id, :company_id, :title, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
   end

end
