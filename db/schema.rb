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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140429235044) do

  create_table "secrets", force: true do |t|
    t.integer  "user_id"
    t.string   "encrypted_key"
    t.string   "encrypted_key_salt"
    t.string   "encrypted_key_iv"
    t.string   "encrypted_value"
    t.string   "encrypted_value_salt"
    t.string   "encrypted_value_iv"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_client_iv"
    t.string   "encrypted_client_iv_salt"
    t.string   "encrypted_client_iv_iv"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
