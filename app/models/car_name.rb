class CarName < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  validates :car_type, presence: true
  validates :name, presence: true, uniqueness: true
  def is_active?
    true # または必要なロジックに置き換えてください
  end
end
