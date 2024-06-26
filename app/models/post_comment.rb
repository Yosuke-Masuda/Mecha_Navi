class PostComment < ApplicationRecord
  belongs_to :employee
  belongs_to :post
  has_many :likes
  
  def liked_by?(employee)
    likes.where(employee_id: employee.id).exists?
  end
end
