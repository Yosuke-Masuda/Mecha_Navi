class Employee::LikesController < ApplicationController
  def create
    @post_comment = PostComment.find(params[:post_comment_id])
    puts "@post_comment: #{@post_comment.inspect}"
    @post = @post_comment.post
    like = @post_comment.likes.new(employee_id: current_employee.id)
    like.save
    flash[:notice] = "Liked post"
    redirect_to request.referer
  end

  def destroy
    @post_comment = PostComment.find(params[:post_comment_id])
    puts "@post_comment: #{@post_comment.inspect}"
    @post = @post_comment.post
    like = current_employee.likes.find_by(post_comment_id: @post_comment.id)
    like.destroy if like
    redirect_to request.referer
  end
end
