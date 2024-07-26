class ApplicationController < ActionController::Base
  before_action :test

  def test
    @company = Company.find(params[:company_id]) if params[:company_id] && controller_name == 'admin/posts' && action_name == 'index'
  end

  private

  def authenticate_employee!
    if !(current_employee && current_employee.is_active?)
      flash[:alert] = "failed"
      sign_out(current_employee)
      redirect_to root_url
    end
  end

  def authenticate_company!
    if !(current_company && current_company.is_active?)
      flash[:alert] = "failed"
      sign_out(current_company)
      redirect_to root_url
    end
  end

end
