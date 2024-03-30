# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

    #POST /resource/sign_in
    def create
      super
      flash[:notice] = "ログインしました。"
    end

     #DELETE /resource/sign_out
    def destroy
     super
     flash[:notice] = "ログアウトしました"# ログイン成功時のメッセージを追加する
    end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end



end
