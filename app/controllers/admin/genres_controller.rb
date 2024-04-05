class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!


  def index
    @genre = Genre.new
    @genres = Genre.all
    @companies = Company.all
  end

  def create
    @genre =Genre.new(genre_params)
    if @genre.save
      flash[:notice] = "作成しました"
      redirect_to admin_genres_path
    else
      @genres = Genre.all
      @companies = Company.all
      render :index
    end

  end

  def edit
    @genre = Genre.find(params[:id])
    @companies = Company.all
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      flash[:notice] = "編集しました"
      redirect_to admin_genres_path
    else
      render "edit"
    end

  end

  private
   def genre_params
    params.require(:genre).permit(:name, :is_active, :company_id)
   end

end
