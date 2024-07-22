class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @employees = Employee.includes(:company).page(params[:page]).order(:name)
  end

end
