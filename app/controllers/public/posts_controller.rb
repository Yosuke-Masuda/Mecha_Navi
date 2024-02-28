class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
    @company = Company.find(current_company.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.store_id = current_company.id
    @post.company_id = current_company.id
    if params[:post][:images]
      @post.images.attach(params[:post][:images])
    end
    if @post.save
      flash[:success] = "作成しました"
      redirect_to public_index_posts_path(@post)
    else
      @posts = Post.all
      @company = Company.find(current_company.id)
      render :new
    end
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

  def post_params
    params.require(:post).permit(:title, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
  end
end

