class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :company, foreign_kye: true
      t.references :employee, foreign_key: true
      t.string :name
      t.string :body
      t.text :memo
      t.date :scheduled_date
      t.boolean :checked, default: false, null: false
      t.timestamps
    end
  end
end
