class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :comment
      t.integer :post_id
      t.integer :user_space_id

      t.timestamps
    end
    add_index :feedbacks, :user_space_id
    add_index :feedbacks, [:post_id, :user_space_id]
  end
end
