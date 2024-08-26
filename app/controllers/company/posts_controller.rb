class Company::PostsController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:index, :show, :edit, :update, :destroy]

  def index
    @posts = current_company.posts.page(params[:page]).order(created_at: :desc)
    @employee = current_company.employees
  end

  def show
    @employee = @company.employees.find(params[:employee_id])
    @post = @employee.posts.find(params[:id])
  end

  def edit
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
      redirect_to company_employee_post_path(@company.id, @post.employee_id, @post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "削除しました"
    redirect_to company_employee_posts_path(@company.id)
  end

  private
    def set_current_company
      if action_name == "index"
        @company = Company.find(params[:company_id])
        if current_company.posts != @company.posts
          redirect_to root_path, alert: "アクセス権限がありません"
        end
      else
        @company = current_company
        @post = @company.posts.find_by(id: params[:id], employee_id: @company.employees)
        if @post.present?
          @post = @post
        else
          redirect_to root_path, alert: "アクセス権限がありません"
        end
      end
    end

    def post_params
      params.require(:post).permit(:company_id, :employee_id, :title, :genre_id, :store_id, :car_name_id, :car_type_id, :image_id, :video_id, :caption, :is_active, images: [])
    end
end
