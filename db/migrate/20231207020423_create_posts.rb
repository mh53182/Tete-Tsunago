class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      
      t.integer :user_id,  null: false
      t.integer :child_id
      t.text    :body,     null: false
      t.integer :category, null: false, default: 0

      t.timestamps
    end
  end
end
