# frozen_string_literal: true

class Company::SessionsController < Devise::SessionsController
  def guest_sign_in
    company = Company.guest
    sign_in company
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  #POST /resource/sign_in
  # def create
  #   super
  # end

  #DELETE /resource/sign_out
  # def destroy
  # super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    if @company.is_active
      top_path
    else
      flash.discard(:notice) # 「ログインしました」メッセージを削除
      flash[:alert] = "無効のアカウントです。"
      sign_out(resource)
      new_company_session_path
    end
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    root_path
  end



end
