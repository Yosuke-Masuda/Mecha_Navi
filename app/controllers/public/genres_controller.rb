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
      redirect_to genres_path
    else
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
      redirect_to genres_path
    else
      render "edit"
    end

  end

  private
   def genre_params
    params.require(:genre).permit(:name, :company_id, :is_active)
   end

end
