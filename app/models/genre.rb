class Genre < ApplicationRecord
  belongs_to :company
  has_many :employees, dependent: :destroy
  has_many :posts, dependent: :destroy


  scope :only_active, -> { where(is_active: true) }

  validates :company_id, presence: true

end
