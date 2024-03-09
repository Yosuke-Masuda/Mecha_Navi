class PostComment < ApplicationRecord
  belongs_to :employee
  belongs_to :post
end
