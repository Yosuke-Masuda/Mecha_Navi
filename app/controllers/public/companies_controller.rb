class Public::CompaniesController < ApplicationController
  def show
    @company = current_company
  end

  def edit
    @company = current_company
  end

  def update
    @company = current_company
    if @company.update(company_params)
      redirect_to companies_path, notice: "登録情報を変更しました"
    else
      render :edit
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
    params.require(:company).permit(:email, :company_name, :company_name_kana, :address, :postal_code, :phone_number)
  end

end
