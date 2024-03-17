class User::PostsController < ApplicationController
  before_action :set_current_employee, only: [:new, :index, :show, :edit, :update, :unsubscribe, :withdraw, :create]
  def index
    @posts = Post.page(params[:page]).order(created_at: :desc) #ページネーションと新しい投稿順に表示
    @images = @posts.map { |post| post.images.map(&:blob) }.flatten.uniq #@postの中から重複を除いた画像を@imagesに代入します。
    @video = @posts.first.video #動画の表示
  end



  def new
   @employee = current_employee #現在のユーザーが所属する会社と従業員の情報を取得します。
   @company = @employee.company #現在のユーザーが所属する会社と従業員の情報を取得します。
   @post = current_employee.posts.build #@postには、現在のユーザーが作成する投稿の情報を設定しています。
  end

  def create
    @post = Post.new(post_params)
    @post.store_id = current_employee.store_id
    @post.company_id = current_employee.company_id if current_employee
    @post.employee_id = current_employee.id
    @post.genre_id = params[:post][:genre_id]
    @post.car_name_id = params[:post][:car_name_id]
     if params[:post].present? && params[:post][:images].present?
      @post.images.attach(params[:post][:images])
     elsif params[:post].present? && params[:post][:video].present?
      @post.video.attach(params[:post][:video])
     end

    if @post.save
     flash[:notice] = "作成しました"
     redirect_to posts_path #indexへ
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
