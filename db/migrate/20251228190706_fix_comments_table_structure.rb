class FixCommentsTableStructure < ActiveRecord::Migration[7.1]
  def change
    # Drop existing table if exists to start fresh, or rename. 
    # Given the weird column names 'discussion' and 'user' (uuid), let's rename them if possible, 
    # but since data might be empty or invalid, let's fix it properly.
    if column_exists? :comments, :discussion
      rename_column :comments, :discussion, :discussion_id
    end

    if column_exists? :comments, :user
      rename_column :comments, :user, :user_id
    end

    add_column :comments, :parent_id, :uuid unless column_exists? :comments, :parent_id
    add_index :comments, :parent_id unless index_exists? :comments, :parent_id
  end
end
