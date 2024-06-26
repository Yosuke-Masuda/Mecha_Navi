class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @employees = Employee.all
  end

end
