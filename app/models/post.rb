class Post < ApplicationRecord
  belongs_to :employee
  belongs_to :store
  belongs_to :company
  belongs_to :genre
  belongs_to :car_name
  has_many_attached :images
  has_one_attached :video
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(employee)
    favorites.where(employee_id: employee.id).exists?
  end
  
  
  #最近の投稿件数を表示するためのメソッド
  def recent_post_count
    Post.where(employee_id: self.employee_id).count
  end
  
  validates :title, presence: true
  validates :caption, presence: true
  
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.joins(:car_name).where("title = ? OR car_names.name = ? OR car_names.car_type = ?", word, word, word)
    elsif search == "forward_match"
      @post = Post.where("title LIKE? OR car_name_id LIKE ? OR car_type_id LIKE ?", "#{word}", "#{word}", "#{word}")
    elsif search == "backward_match"
      @post = Post.where("title LIKE? OR car_name_id LIKE ? OR car_type_id LIKE ?", "#{word}", "#{word}", "#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE? OR car_name_id LIKE ? OR car_type_id LIKE ?", "#{word}", "#{word}", "#{word}")
    else
      @post = Post.all
    end
  end
end
