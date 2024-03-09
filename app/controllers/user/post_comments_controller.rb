class User::PostCommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = current_employee.post_comments.new(post_comment_params)
    comment.post_id = post.id
    comment.save
    redirect_to post_path(post)
  end

  def destroy
  comment = PostComment.find_by(id: params[:id])
  if comment
    comment.destroy
    redirect_to post_path(params[:post_id])
  else
    flash[:alert] = '対象のコメントが見つかりませんでした。'
    redirect_to post_path(params[:post_id])
  end
end
  
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
end
