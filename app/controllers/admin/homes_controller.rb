class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @employees = Employee.all
    @companies = Company.page(params[:page]).order(created_at: :desc)
  end
end
