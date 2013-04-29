class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :reward
      t.references :user

      t.timestamps
    end

  end
end
