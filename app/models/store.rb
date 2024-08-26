class Store < ApplicationRecord
  belongs_to :company

  has_many :employees, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company_id }

  scope :only_active, -> { where(is_active: true) }
end
