class Task < ApplicationRecord
  belongs_to :company

  has_many :daily_tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :body, presence: true, uniqueness: { scope: :company_id }
end
