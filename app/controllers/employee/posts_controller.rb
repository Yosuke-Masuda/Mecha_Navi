class Employee::PostsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_current_employee, only: [:show, :edit, :update, :destroy]

  def new
    @employee = current_employee
    @company = @employee.company
    @post = current_employee.posts.build
    @genres = current_employee.company.genres
    @car_names = current_employee.company.car_names
  end

  def create
    @post = Post.new(post_params)
    @post.store_id = current_employee.store_id
    @post.company_id = current_employee.company_id if current_employee
    @post.employee_id = current_employee.id
    @post.genre_id = params[:post][:genre_id]
    @post.car_name_id = params[:post][:car_name_id]
    @genres = current_employee.company.genres
    @car_names = current_employee.company.car_names

    if @post.save
     flash[:notice] = "作成しました"
     redirect_to posts_path
    else
     @posts = Post.all
     @company = Company.find(current_employee.company_id)
     render :new
    end
  end

  def index
    @company = current_employee.company
    @posts = Post.where(company_id: [@company.id, current_employee.company_id]).page(params[:page]).order(created_at: :desc)
    @images = @posts.map { |post| post.images.map(&:blob) }.flatten.uniq #@postの中から重複を除いた画像を@imagesに代入します。
    @video = @posts.first.present? ? @posts.first.video : nil
  end

  def show
    @post_comment = PostComment.new
  end

  def edit
    @genres = current_employee.company.genres
    @car_names = current_employee.company.car_names
  end

  def update
    if params[:post][:image_ids]
       params[:post][:image_ids].each do |image_id|
        image = @post.images.find(image_id)
        image.purge
      end
    end
    if @post.update(post_params)
      flash[:notice] = "編集しました"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:alert] = "削除しました"

    if request.referer == history_employee_url(current_employee.id) # employees/history.html.erbからのアクセスの場合
     redirect_to history_employee_path(current_employee.id)
    else # employees/posts/index.html.erbからのアクセスの場合
     redirect_to posts_path
    end
  end

  private

  def set_current_employee
    @post = current_employee.posts.find_by(id: params[:id])
    if @post.present? && @post.company_id == current_employee.id
      @post = Post.find(params[:id])
    else
      redirect_to posts_path, alert: 'アクセス権限がありません'
    end
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:employee_id, :company_id, :title, :store_id, :genre_id, :car_name_id, :car_type_id, :video, :caption, :is_active, images: [])
  end
end
