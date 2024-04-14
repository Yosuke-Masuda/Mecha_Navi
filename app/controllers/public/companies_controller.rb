class Public::CompaniesController < ApplicationController


  def show
    @company = Company.find(params[:id])
  end

  def edit
    @company = Company.find(params[:id])
    render "edit"
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to company_path(id: @company.id), notice: "登録情報を変更しました"
    else
      render "edit"
    end
  end

  def unsubscribe
    @company = Company.find(params[:id])
  end

  def withdraw
    @company = Company.find(params[:id])
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
