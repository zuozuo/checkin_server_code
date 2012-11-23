class CreateUsers < ActiveRecord::Migration
  add_column :users, :name, :string
  add_index :users, :name
end
