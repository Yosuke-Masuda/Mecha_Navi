class Public::PostsController < ApplicationController
  before_action :set_current_company, only: [:index, :show, :edit, :update, :unsubscribe, :withdraw, :create]
  
  def index
    @posts = Post.all
    @posts = Post.order(created_at: :desc)
    @company = Company.find(current_company.id)
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
    if post.update_attributes(post_params)
      flash[:success] = "編集しました"
      redirect_to posts_url
    else
      render :edit
    end
  end


  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "作成しました"
    redirect_to posts_path
  end

  private
  
  def set_current_company
    @company = current_company
  end

  def post_params
    params.require(:post).permit(:employee_id, :company_id, :title, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
  end
end
