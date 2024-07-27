class CarName < ApplicationRecord

  belongs_to :company

  has_many :posts, dependent: :destroy
  has_many :employees, dependent: :destroy

  validates :name, presence: true
  validates :car_type, presence: true, uniqueness: { scope: :company_id }

  scope :only_active, -> { where(is_active: true) }

end
