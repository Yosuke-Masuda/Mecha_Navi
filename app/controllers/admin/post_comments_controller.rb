class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post_comment, only: [:destroy]


  def destroy
    if @post_comment
      @post_comment.destroy
      flash[:alert] = "削除しました"
    else
      flash[:alert] = "対象のコメントが見つかりませんでした。"
    end
    redirect_to admin_company_employee_post_path(params[:company_id], params[:employee_id], params[:post_id])
  end

  private
    def set_post_comment
      @post_comment = PostComment.find_by(id: params[:id])
    end
end
