class Genre < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  #scope :only_active, -> { where(is_active: true) }

  validates :name, presence: true, uniqueness: true
  def is_active?
    true # または必要なロジックに置き換えてください
  end
end
