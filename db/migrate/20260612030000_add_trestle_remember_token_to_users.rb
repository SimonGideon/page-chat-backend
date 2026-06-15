class AddTrestleRememberTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_token, :string
    add_column :users, :remember_token_expires_at, :datetime
    add_index :users, :remember_token, unique: true
  end
end
