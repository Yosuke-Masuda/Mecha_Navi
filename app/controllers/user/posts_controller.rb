class User::PostsController < ApplicationController
  before_action :set_current_employee, only: [:new, :index, :show, :edit, :update, :unsubscribe, :withdraw, :create]
  def index
    @posts = Post.order(created_at: :desc)
    @post = @posts.first
    @images = @post.images
    @post = @post.video
  end
  
  
  
  def new
   @post = Post.new
   @employee = current_employee
   @company = @employee.company
   @post = current_employee.posts.build
   @genres = @company.genres
   @car_names = @company.car_names
  end
  
  def create
    @post = Post.new(post_params)
    @post.store_id = current_employee.store_id
    @post.company_id = current_employee.company_id if current_employee
    @post.employee_id = current_employee.id
    @post.genre_id = params[:post][:genre_id]
    @post.car_name_id = params[:post][:car_name_id]
    if params[:post][:images]
      @post.images.attach(params[:post][:images])
    end
    
    if @post.save
     flash[:success] = "作成しました"
     redirect_to posts_path
    else
     @posts = Post.all
     @company = Company.find(current_employee.company_id)
     render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @images = @post.images
    @video = @post.video
    @post_comment = PostComment.new
  end  
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    post = Post.find(params[:id])
    if params[:post][:image_ids]
      params[:post][:image_ids].each do |image_id|
        image = post.images.find(image_id)
        image.purge
      end
    end
    if post.update(post_params)
      
      flash[:success] = "編集しました"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "削除しました"
    redirect_to posts_path
  end

  private
  
  def set_current_employee
    @employee = current_employee
  end

  def post_params
    params.require(:post).permit(:employee_id, :company_id, :title, :store_id, :genre_id, :car_name_id, :car_type_id, :video, :caption, :is_active, images: [])
  end
end
