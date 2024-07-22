class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @employees = Employee.all
    @companies = Company.all
  end

end
