class User::FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(employee_id: current_employee.id)
    favorite.save
    flash[:notice] = "いいねしました"
    redirect_to request.referer
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_employee.favorites.find_by(post_id: @post.id)
    favorite.destroy
    redirect_to request.referer
  end

end
