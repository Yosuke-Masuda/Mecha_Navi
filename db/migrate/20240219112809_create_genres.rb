class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.integer :company_id, null: false
      t.string :name, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
