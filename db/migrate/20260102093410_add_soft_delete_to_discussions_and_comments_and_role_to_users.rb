class AddSoftDeleteToDiscussionsAndCommentsAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    # For Discussions
    add_column :discussions, :deleted, :boolean, default: false
    add_column :discussions, :deleted_at, :datetime
    add_column :discussions, :deleted_by_id, :uuid
    add_column :discussions, :deletion_reason, :string

    add_index :discussions, :deleted
    add_index :discussions, :deleted_at
    add_index :discussions, :deleted_by_id
    add_foreign_key :discussions, :users, column: :deleted_by_id

    # For Users
    add_column :users, :role, :integer, default: 0
  end
end
