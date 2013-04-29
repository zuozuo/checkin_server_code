# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121123085356) do

  create_table "feedbacks", :force => true do |t|
    t.string   "comment"
    t.integer  "post_id"
    t.integer  "user_space_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feedbacks", ["post_id", "user_space_id"], :name => "index_feedbacks_on_post_id_and_user_space_id"
  add_index "feedbacks", ["user_space_id"], :name => "index_feedbacks_on_user_space_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "reward"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "types"
  end

  add_index "posts", ["user_id", "types"], :name => "index_posts_on_user_id_and_types"

  create_table "shares", :force => true do |t|
    t.string   "post_id"
    t.integer  "user_space_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "shares", ["post_id"], :name => "index_shares_on_post_id"
  add_index "shares", ["user_space_id"], :name => "index_shares_on_user_space_id"

  create_table "user_spaces", :force => true do |t|
    t.string   "name"
    t.string   "social"
    t.integer  "types"
    t.integer  "user_id"
    t.integer  "share_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_spaces", ["name", "social", "types"], :name => "index_user_spaces_on_name_and_social_and_types"
  add_index "user_spaces", ["social", "types"], :name => "index_user_spaces_on_social_and_types"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
