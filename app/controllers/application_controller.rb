class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

   def after_sign_in_path_for(resource)
     case resource
     when Admin
       flash[:notice] = "ログインに成功しました"
       admin_root_path
     when Company
       company_path(@company.id)
     when Employee
       flash[:notice] = "ログインに成功しました"
       mypage_path(@employee.id)
     end
   end

   def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :company
     new_company_session_path
    elsif resource_or_scope == :admin
     new_admin_session_path
    elsif resource_or_scope == :employee
     flash[:alert] = "ログアウトしました"
     new_employee_session_path
    else
     root_path
    end

   end


   protected
       #新規登録保存機能
     def configure_permitted_parameters
       devise_parameter_sanitizer.permit(:sign_up, keys: [:company_id, :company_name, :company_name_kana, :name, :first_name, :last_name, :first_name_kana, :last_name_kana, :postal_code, :phone_number, :address, :store_id, :employee_id, :post_id])
        #sign_upの際にnaameのデータ操作を許可。追加したカラム
       devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation])
     end
end
