class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      
      t.integer :user_id,  null: false
      t.string  :nickname, null: false
      t.date    :birthday

      t.timestamps
    end
  end
end
