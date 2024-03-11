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
  
  
  validates :title, presence: true
  validates :caption, presence: true
end
