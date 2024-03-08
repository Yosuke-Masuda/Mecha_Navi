class Genre < ApplicationRecord
  belongs_to :company
  belongs_to :employee
  has_many :posts
  
  
  scope :only_active, -> { where(is_active: true) }
  
  validates :company_id, presence: true
end
