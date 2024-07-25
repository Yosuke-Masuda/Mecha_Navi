class Employee::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_employee.favorites.find_or_create_by(post_id: @post.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_employee.favorites.find_by(post_id: @post.id)
    favorite.destroy if favorite
  end

end
