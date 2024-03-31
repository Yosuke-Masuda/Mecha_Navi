class Public::GenresController < ApplicationController
  before_action :authenticate_company!
  def index
    @genre = Genre.new
    @genres = current_company.genres

  end
  
  
  
  def create
    @genre =Genre.new(genre_params)
    @genre.company_id = current_company.id
    if @genre.save
      flash[:notice] = "作成しました"
      redirect_to genres_path
    else
      flash[:alert] = "作成に失敗しました"
      @genres = current_company.genres  
      render :index
    end

  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      flash[:notice] = "編集しました"
      redirect_to genres_path
    else
      flash[:alert] = "編集に失敗しました"
      render "edit"
    end

  end

  private
   def genre_params
    params.require(:genre).permit(:name, :company_id, :is_active)
   end

end
