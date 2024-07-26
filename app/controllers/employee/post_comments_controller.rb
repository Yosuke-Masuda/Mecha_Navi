class Employee::PostCommentsController < ApplicationController
  before_action :authenticate_employee!
  before_action :correct_employee, only: [:destroy]
  
  def create
    post = Post.find(params[:post_id])
    comment = current_employee.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
      flash[:notice] = "コメントが保存されました"
    else
      flash[:alert] = "コメントの保存に失敗しました"
    end
    redirect_to post_path(post)
  end

  def destroy
    comment = PostComment.find_by(id: params[:id])
    if comment
      comment.destroy
      flash[:alert] = '削除しました'  # フラッシュメッセージをセット
    else
      flash[:alert] = '対象のコメントが見つかりませんでした。'  # フラッシュメッセージをセット
    end
    redirect_to post_path(params[:post_id])  # 処理の結果に応じてリダイレクト
  end


  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
  def correct_employee
    @post_comment = current_employee.post_comments.find_by(id: params[:id])
  end

end
