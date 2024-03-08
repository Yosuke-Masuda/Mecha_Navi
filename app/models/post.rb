class Post < ApplicationRecord
  belongs_to :employee
  belongs_to :store
  belongs_to :company
  belongs_to :genre
  belongs_to :car_name
  has_many_attached :images
  
  validates :title, presence: true
  validates :caption, presence: true
end
