class Store < ApplicationRecord
  belongs_to :company
  has_many :employees
  
  scope :only_active, -> { where(is_active: true) }
  
  validates :company_id, presence: true
end