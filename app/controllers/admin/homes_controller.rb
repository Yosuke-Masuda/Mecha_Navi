class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @employees = Employee.page(params[:page]).order(created_at: :desc)
  end

end
