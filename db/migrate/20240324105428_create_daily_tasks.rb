class CreateDailyTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_tasks do |t|
      t.references :task, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.datetime :start_time

      t.timestamps
    end
  end
end
