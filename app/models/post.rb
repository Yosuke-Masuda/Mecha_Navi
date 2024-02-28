class Post < ApplicationRecord
  belongs_to :employee
  belongs_to :store
  belongs_to :company
  has_many :genres
  has_many_attached :images
  
  validates :images, presence: true
  validates :title, presence: true
  validates :car_name_id, presence: true
  validates :car_type_id, presence: true
  validates :genre_id, presence: true
  validates :image_id, presence: true
  validates :video_id, presence: true
  validates :caption, presence: true
end
