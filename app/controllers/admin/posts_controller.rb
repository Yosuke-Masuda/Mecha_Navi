class Admin::PostsController < ApplicationController
  def index
    @company = Company.where(id: 1).first
    @employees = @company.employees # 企業に所属する社員を取得
    @recent_posts = @company.employees.first.posts.order(created_at: :desc).limit(10) # 最近の投稿を取得する例として、最新10件を取得しています
    @all_posts_count = @company.employees.first.posts.count # 投稿全件数を取得しています

    respond_to do |format|
      format.html
    end
  end
end
