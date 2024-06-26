class Task < ApplicationRecord
  belongs_to :company
  has_many :daily_tasks, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true
end
