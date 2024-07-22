class PostComment < ApplicationRecord
  belongs_to :employee
  belongs_to :post
  has_many :likes
  
  def liked_by?(employee)
    likes.where(employee_id: employee.id).exists?
  end
  
  
  def written_by?(current_employee)#`current_employee`オブジェクトが「書いた」という条件をチェックして真偽値（trueまたはfalse）を返します。
    self.employee == current_employee
  end
  
end
