class FixDiscussionsColumns < ActiveRecord::Migration[7.1]
  def change
    # --- Rename columns safely ---
    rename_column :discussions, :user, :user_id if column_exists?(:discussions, :user)
    rename_column :discussions, :book, :book_id if column_exists?(:discussions, :book)

    # --- Remove old indexes safely ---
    if index_exists?(:discussions, :user)
      remove_index :discussions, column: :user
    end

    if index_exists?(:discussions, :book)
      remove_index :discussions, column: :book
    end

    # --- Add correct indexes ---
    add_index :discussions, :user_id unless index_exists?(:discussions, :user_id)
    add_index :discussions, :book_id unless index_exists?(:discussions, :book_id)

    # --- Add counter cache ---
    unless column_exists?(:discussions, :comments_count)
      add_column :discussions, :comments_count, :integer, default: 0, null: false
    end
  end
end
