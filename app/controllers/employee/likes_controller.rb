class Employee::LikesController < ApplicationController
  before_action :authenticate_employee!

  def create
    @post_comment = PostComment.find(params[:post_comment_id])
    puts "@post_comment: #{@post_comment.inspect}"
    @post = @post_comment.post
    current_employee.likes.find_or_create_by(post_comment_id: @post_comment.id)
  end

  def destroy
    @post_comment = PostComment.find(params[:post_comment_id])
    puts "@post_comment: #{@post_comment.inspect}"
    @post = @post_comment.post
    like = current_employee.likes.find_by(post_comment_id: @post_comment.id)
    like.destroy if like
  end
end
