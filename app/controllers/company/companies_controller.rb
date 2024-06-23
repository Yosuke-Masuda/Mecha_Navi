class Company::CompaniesController < ApplicationController
  before_action :authenticate_company!
  before_action :ensure_normal_company, only: [:update, :unsubscribe]

  def ensure_normal_company
    @company = current_company
    if current_company.email == 'guest_company@example.com'
      redirect_to edit_company_mypage_path, alert: 'ゲストユーザーでは権限がありません'
    end
  end


  def show
    @company = current_company
  end

  def edit
    @company = current_company
    render "edit"
  end

  def update
    @company = current_company
    if @company.update(company_params)
      redirect_to companies_mypage_path, notice: "登録情報を変更しました"
    else
      render "edit"
    end
  end

  def unsubscribe
    @company = current_company
  end

  def withdraw
    @company = current_company
    @company.update(is_active: false)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用お待ちしております。"
    redirect_to root_path
  end


  private

  def company_params
    params.require(:company).permit(:email, :company_name, :company_name_kana, :address, :postal_code, :phone_number, :password, :password_confirmation,)
  end

end
