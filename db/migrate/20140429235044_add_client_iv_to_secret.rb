class AddClientIvToSecret < ActiveRecord::Migration
  def change
    add_column :secrets, :encrypted_client_iv, :string
    add_column :secrets, :encrypted_client_iv_salt, :string
    add_column :secrets, :encrypted_client_iv_iv, :string
  end
end
