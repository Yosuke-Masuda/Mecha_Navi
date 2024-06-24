class Company::GenresController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:edit, :update]
  before_action :ensure_normal_company, only: :update



  def index
    @genre = Genre.new
    @genres = current_company.genres

  end

  def create
    @genre =Genre.new(genre_params)
    @genre.company_id = current_company.id
    if @genre.save
      flash[:notice] = "作成しました"
      redirect_to company_genres_path(current_company.id)
    else
      @genres = current_company.genres
      render :index
    end

  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      flash[:notice] = "編集しました"
      redirect_to company_genres_path(current_company.id)
    else
      render "edit"
    end

  end

  private

  def set_current_company
    @genre = current_company.genres.find_by(id: params[:id])
    if @genre.present? && @genre.company_id == current_company.id
      @genre = Genre.find(params[:id])
    else
      redirect_to company_genres_path(current_company.id), alert: 'アクセス権限がありません'
    end
  end

  def ensure_normal_company
    @genre = Genre.find(params[:id])
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_genre_path(current_company.id, @genre), alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def genre_params
    params.require(:genre).permit(:name, :company_id, :is_active)
  end

end
