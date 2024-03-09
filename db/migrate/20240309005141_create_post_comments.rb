class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :post, foreign_key: true
      t.references :employee, foreign_key: true
      t.text :comment, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
