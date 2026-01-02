class AddSoftDeleteToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :deleted_at, :datetime
    add_column :comments, :deleted_by_id, :uuid
    add_column :comments, :deletion_reason, :string

    unless column_exists?(:comments, :deleted)
      add_column :comments, :deleted, :boolean, default: false, null: false
    end

    add_index :comments, :deleted unless index_exists?(:comments, :deleted)
    add_index :comments, :deleted_at unless index_exists?(:comments, :deleted_at)
    add_index :comments, :deleted_by_id unless index_exists?(:comments, :deleted_by_id)

    add_foreign_key :comments, :users, column: :deleted_by_id
  end
end
