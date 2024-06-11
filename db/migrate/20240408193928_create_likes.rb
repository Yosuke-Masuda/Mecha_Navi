class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :employee_id, null: false
      t.integer :post_comment_id, null: false
      t.timestamps
    end
  end
end
