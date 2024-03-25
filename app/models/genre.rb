class Genre < ApplicationRecord
  belongs_to :company
  has_many :employees
  has_many :posts
  
  
  scope :only_active, -> { where(is_active: true) }
  
  validates :company_id, presence: true
end
