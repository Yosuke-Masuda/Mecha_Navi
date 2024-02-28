class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :company, fogen_key: true
      t.integer :store_id, null: false
      t.integer :employee_id, null: false
      t.integer :car_name_id, null: false
      t.integer :car_type_id, null: false
      t.string :title, null: false
      t.string :genre_id, null: false
      t.string :image_id, null: false
      t.string :video_id, null: false
      t.text :caption, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
