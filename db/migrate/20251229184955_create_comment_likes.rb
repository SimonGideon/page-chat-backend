class CreateCommentLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_likes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :comment_id, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end

    # Prevent duplicate likes
    add_index :comment_likes, [:comment_id, :user_id], unique: true

    # Fast lookups
    add_index :comment_likes, :comment_id
    add_index :comment_likes, :user_id

    # Counter cache on comments
    add_column :comments, :likes_count, :integer, default: 0, null: false
    add_index :comments, :likes_count

    # Foreign keys
    add_foreign_key :comment_likes, :comments
    add_foreign_key :comment_likes, :users
  end
end
