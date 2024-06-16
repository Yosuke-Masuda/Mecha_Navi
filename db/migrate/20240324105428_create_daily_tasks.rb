class CreateDailyTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_tasks do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :task_id, null: false
      t.datetime :start_time
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
