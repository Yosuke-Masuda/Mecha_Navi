class ApplicationController < ActionController::Base
  before_action :test

  def test
    @company = Company.find(params[:company_id]) if params[:company_id] && controller_name == "admin/posts" && action_name == "index"
  end
end
