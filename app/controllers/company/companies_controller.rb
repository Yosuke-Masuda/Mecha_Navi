class Company::CompaniesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_current_company, only: [:show, :edit, :update, :unsubscribe, :withdraw]
  before_action :ensure_normal_company, only: [:update, :unsubscribe]

  def show
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_mypage_path, notice: "登録情報を変更しました"
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  def withdraw
    @company.update(is_active: false)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用お待ちしております。"
    redirect_to root_path
  end


  private

  def set_current_company
    @company = current_company
  end

  def ensure_normal_company
    @company = current_company
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_mypage_path, alert: 'ゲストユーザーでは権限がありません'
    end
  end

  def company_params
    params.require(:company).permit(:email, :company_name, :company_name_kana, :address, :postal_code, :phone_number, :password, :password_confirmation,)
  end

end
