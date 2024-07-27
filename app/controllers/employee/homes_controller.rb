class Employee::HomesController < ApplicationController
  
  def top
    if current_employee
      @company = current_employee.company
      @posts = Post.where(company_id: [@company.id, current_employee.company_id]).order(created_at: :desc).limit(5)
      @images = @posts.map { |post| post.images.map(&:blob) }.flatten.uniq #@postの中から重複を除いた画像を@imagesに代入します。
      @video = @posts.first.present? ? @posts.first.video : nil
    end
  end
end
