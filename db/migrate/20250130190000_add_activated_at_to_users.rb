class AddActivatedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activated_at, :datetime, null: true
    add_index :users, :activated_at
  end
end

