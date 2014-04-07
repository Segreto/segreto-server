class DropDoorkeeperTables < ActiveRecord::Migration
  def up
    drop_table :oauth_access_grants
    drop_table :oauth_access_tokens
    drop_table :oauth_applications
  end

  def down
    create_table :oauth_access_grants do |t|
      t.integer  "resource_owner_id", null: false
      t.integer  "application_id",    null: false
      t.string   "token",             null: false
      t.integer  "expires_in",        null: false
      t.text     "redirect_uri",      null: false
      t.datetime "created_at",        null: false
      t.datetime "revoked_at"
      t.string   "scopes"
    end

    add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

    create_table "oauth_access_tokens", force: true do |t|
      t.integer  "resource_owner_id"
      t.integer  "application_id"
      t.string   "token",             null: false
      t.string   "refresh_token"
      t.integer  "expires_in"
      t.datetime "revoked_at"
      t.datetime "created_at",        null: false
      t.string   "scopes"
    end

    add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

    create_table "oauth_applications", force: true do |t|
      t.string   "name",         null: false
      t.string   "uid",          null: false
      t.string   "secret",       null: false
      t.text     "redirect_uri", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end
end
