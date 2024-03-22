class Task < ApplicationRecord
  belongs_to :company
  belongs_to :employee, optional: true

  def completed
    # タスクの完了状態を判断するためのロジックを実装する
    self.completed?
  end
end
