class AddTypesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :types, :integer
    add_index :posts, [:user_id, :types]
  end
end
