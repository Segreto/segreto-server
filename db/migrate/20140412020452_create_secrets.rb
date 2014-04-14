class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.integer :user_id
      t.string :encrypted_key
      t.string :encrypted_key_salt
      t.string :encrypted_key_iv
      t.string :encrypted_value
      t.string :encrypted_value_salt
      t.string :encrypted_value_iv

      t.timestamps
    end
  end
end
