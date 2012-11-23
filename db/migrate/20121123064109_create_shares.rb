class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :post_id
      t.integer :user_space_id

      t.timestamps
    end
    add_index :shares, :post_id
    add_index :shares, :user_space_id
  end
end
