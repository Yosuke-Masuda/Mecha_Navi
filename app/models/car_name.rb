class CarName < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :company
  has_many :employees, dependent: :destroy


  scope :only_active, -> { where(is_active: true) }

  validates :company_id, presence: true
  validates :name, presence: true
  validates :car_type, presence: true
end
