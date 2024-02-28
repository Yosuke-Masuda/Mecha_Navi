class Public::CarNamesController < ApplicationController


  def index
    @car_name = CarName.new
    @car_names = CarName.all
  end

  def create
    @car_name = CarName.new(car_name_params)
    if @car_name.save
      redirect_to car_names_path
    else
      @car_names = CarName.all
      render :index
    end

  end

  def edit
   @car_name = CarName.find(params[:id])
  end

  def update
    @car_name = CarName.find(params[:id])
    if @car_name.update(car_name_params)
      redirect_to car_names_path
    else
      render "edit"
    end

  end

  private
   def car_name_params
    params.require(:car_name).permit(:name, :car_type)
   end
end
