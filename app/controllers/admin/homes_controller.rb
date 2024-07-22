class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @companies = Company.all
    @employees = Employee.page(params[:page]).order(:name)
  end

end
