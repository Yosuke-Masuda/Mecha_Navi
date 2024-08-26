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

  validates :car_type_id, presence: true
  validates :title, presence: true
  validates :caption, presence: true, length: { maximum: 500 }

  scope :only_active, -> { where(is_active: true) }

  def written_by?(employee)
    employee_id == employee.id
  end

  def favorited_by?(employee)
    favorites.where(employee_id: employee.id).exists?
  end

  # 最近の投稿件数を表示するためのメソッド
  def recent_post_count
    Post.where(employee_id: self.employee_id).count
  end

  def self.looks(genre_id, word)
    @posts = self.joins(:car_name, :genre)
    @posts = @posts.where(genre_id: genre_id) if genre_id.present?
    if word.present?
      @posts = @posts.where("title LIKE ? OR car_names.name LIKE ? OR car_names.car_type LIKE ?", "%#{word}%", "%#{word}%", "%#{word}%")
    end
    @posts = @posts.order(created_at: :desc)
  end

  # admin/posts controller/indexのリファクタリング
  def self.get_company(company_id, now_page)
    where(company_id: company_id).group(:employee_id).page(now_page).order(created_at: :desc) # 最近の投稿
  end

  def self.get_all_posts_count_by_employee(company_id)
    where(company_id: company_id).group(:employee_id).count
  end

  def self.get_favorite(company_id)
    joins(:favorites).where(company_id: company_id).group(:employee_id).count # いいねされた全件数
  end
end
