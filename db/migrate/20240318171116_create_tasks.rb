class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :company, foreign_kye: true
      t.string :name, null: false
      t.string :body, null: false
      t.timestamps
    end
  end
end
