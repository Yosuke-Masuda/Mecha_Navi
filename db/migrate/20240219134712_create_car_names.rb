class CreateCarNames < ActiveRecord::Migration[6.1]
  def change
    create_table :car_names do |t|
      t.integer :company_id, null: false
      t.string :name, null: false
      t.string :car_type, null: false
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
  end
end
