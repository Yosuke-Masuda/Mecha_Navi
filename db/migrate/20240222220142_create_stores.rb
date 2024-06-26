class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.integer :company_id
      t.string :name
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
