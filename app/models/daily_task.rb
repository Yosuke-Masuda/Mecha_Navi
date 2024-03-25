class DailyTask < ApplicationRecord
  belongs_to :task
  belongs_to :employee
  belongs_to :company, optional: true
end
