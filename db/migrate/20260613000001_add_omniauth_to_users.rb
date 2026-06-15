class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    # provider: "google" (or "github" etc in the future)
    # uid: the unique ID Google assigns this user — never changes
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    # Together they must be unique — one Google account = one app account
    add_index :users, [:provider, :uid], unique: true
  end
end
