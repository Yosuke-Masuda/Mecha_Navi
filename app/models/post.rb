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


  def self.looks(genre_id, word)
    posts = self.joins(:car_name, :genre)
    posts = posts.where(genre_id: genre_id) if genre_id.present?
    if word.present?
      posts = posts.where("title LIKE ? OR car_names.name LIKE ? OR car_names.car_type LIKE ?", "%#{word}%", "%#{word}%", "%#{word}%")
    end
    posts = posts.order(created_at: :desc)
  end
end
