class Post < ApplicationRecord
  belongs_to :employee
  belongs_to :store
  belongs_to :company
  has_many :genres
  has_many :car_names
  has_many_attached :images
  
  validates :title, presence: true
  validates :caption, presence: true
end
