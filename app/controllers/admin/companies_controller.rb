class Admin::CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_company, only: [:show, :edit, :update]

  def index
    @companies = Company.page(params[:page]).order(:name)
  end

  def show
  end

  def edit
  end

  def update
    @company.update(company_params) ? (redirect_to admin_company_path(@company), notice: "更新しました") : (render :edit, alert: "失敗しました")
  end

  private

  def company_params
    params.require(:company).permit(:company_name, :company_name_kana, :email, :postal_code, :address, :phone_number, :is_active)
  end

  def ensure_company
    @company = Company.find(params[:id])
  end
end

