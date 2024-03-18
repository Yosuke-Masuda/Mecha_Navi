class Task < ApplicationRecord
  belongs_to :company
  belongs_to :employee
end
