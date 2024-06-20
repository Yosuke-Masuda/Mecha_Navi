class Employee::PostsController < ApplicationController
  before_action :set_current_employee, only: [:new, :index, :show, :edit, :update, :unsubscribe, :withdraw, :create]
  def index
    @company = current_employee.company
    @posts = Post.where(company_id: [@company.id, current_employee.company_id]).page(params[:page]).order(created_at: :desc)
    @images = @posts.map { |post| post.images.map(&:blob) }.flatten.uniq #@postの中から重複を除いた画像を@imagesに代入します。
    @video = @posts.first.present? ? @posts.first.video : nil

  end



  def new
    @employee = current_employee #所属する会社と従業員の情報を取得します。
    @company = @employee.company #所属する会社と従業員の情報を取得します。
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

  def show
    @post = Post.find(params[:id])
    @images = @post.images.map(&:blob).uniq
    @video = @post.video
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @genres = current_employee.company.genres
    @car_names = current_employee.company.car_names
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

      flash[:notice] = "編集しました"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
   @post = Post.find(params[:id])
   @post.destroy
   flash[:alert] = "削除しました"

   if request.referer == post_path(@post)
     redirect_to posts_path
   else
     redirect_to mypage_path
   end
  end

  private

  def set_current_employee
    @employee = current_employee #現在のユーザー（従業員）の情報を設定するために使用されます。
  end

  def post_params
    params.require(:post).permit(:employee_id, :company_id, :title, :store_id, :genre_id, :car_name_id, :car_type_id, :video, :caption, :is_active, images: [])
  end
end
