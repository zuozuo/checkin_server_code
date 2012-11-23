class CreateUserSpaces < ActiveRecord::Migration
  def change
    create_table :user_spaces do |t|
      t.string :name
      t.string :social
      t.integer :types
      t.references :user
      t.references :share

      t.timestamps
    end

    add_index :user_spaces, [:social, :types]
    add_index :user_spaces, [:name, :social, :types]

  end
end
