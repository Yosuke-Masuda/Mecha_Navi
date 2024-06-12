class Company::PostsController < ApplicationController
  before_action :set_current_company, only: [:index, :show, :edit, :update, :unsubscribe, :withdraw]

  def index
    @posts = Post.where(company_id: current_company.id).page(params[:page]).order(created_at: :desc) #他の企業の社員の投稿を見れないようにする
    @company = Company.find(params[:company_id])
    @employee = Employee.find(params[:employee_id])

  end

  def show
    @company = Company.find(params[:company_id])
    @employee = Employee.find(params[:employee_id])
    @post = Post.find(params[:id])
    @posts = @employee.posts
    @images = @post.images.map(&:blob).uniq
    @video = @post.video
  end

  def edit
    @post = Post.find(params[:id])
  end


  def update
    post = Post.find(params[:id])
    if params[:post][:image_ids]
       params[:post][:image_ids].each do |image_id|
        image = post.images.find_by_id(image_id)
        image.purge if image
       end
    end
    if post.update(post_params)
      flash[:notice] = "編集しました"
      redirect_to company_employee_post_path(company_id: current_company.id, employee_id: post.employee_id, id: post.id)
    else
      render :edit
    end
  end


  def destroy
   @post = Post.find(params[:id])
   @post.destroy
   flash[:notice] = "削除しました"
   redirect_to company_employee_posts_path(company_id: current_company.id, employee_id: current_company.employee_ids.first)
  end

  private

  def set_current_company
    @company = current_company
  end

  def post_params
    params.require(:post).permit(:company_id, :employee_id, :title, :genre_id, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
  end
end

