class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_post, only: [:show, :edit, :update, :destroy]

  def index
    @company = Company.find(params[:company_id])
    @recent_posts = Post.get_company(@company.id, params[:page]) # 最近の投稿
    @all_posts_count_by_employee = Post.get_all_posts_count_by_employee(@company.id) # 社員１人が投稿した全件数
    @favorites_count_by_employee = Post.get_favorite(@company.id) # いいねされた全件数
  end

  def history
    @company = Company.find(params[:company_id])
    @employee = Employee.find(params[:employee_id])
    @posts = @employee.posts.page(params[:page]).order(created_at: :desc)
  end

  def show
    @employee = @post.employee # @employeeを@postから取得する
    @posts = @employee.posts
  end

  def edit
    @company = Company.find(params[:company_id])
    @genres = @company.genres
    @car_names = @company.car_names
  end


  def update
    if params[:post][:image_ids]
      params[:post][:image_ids].each do |image_id|
        image = @post.images.find_by_id(image_id)
        image.purge if image
      end
    end
    if @post.update(post_params)
      flash[:notice] = "編集しました"
      redirect_to admin_company_employee_post_path(company_id: @post.company_id, employee_id: @post.employee_id, id: @post.id)
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy

      redirect_to history_admin_company_employee_posts_path(@post.employee.company, @post.employee), notice: "投稿を削除しました。"
    else
      redirect_to history_admin_company_employee_posts_path(@post.employee.company, @post.employee), alert: "投稿の削除に失敗しました。"
    end
  end

  private
    def ensure_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:employee_id, :company_id, :title, :genre_id, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
    end
end
