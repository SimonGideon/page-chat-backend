class CreateReadingPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :reading_positions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :user_id, null: false
      t.uuid :book_id, null: false

      # PDF reading position
      t.integer :page_number, null: false
      t.float :scroll_offset # value between 0.0 - 1.0 (optional)

      # Reading progress
      t.float :percentage_completed

      t.datetime :last_read_at, null: false

      t.timestamps
    end

    # Ensure one reading position per user per book
    add_index :reading_positions, [:user_id, :book_id], unique: true

    # Performance indexes
    add_index :reading_positions, :user_id
    add_index :reading_positions, :book_id
    add_index :reading_positions, :last_read_at

    # Foreign keys
    add_foreign_key :reading_positions, :users
    add_foreign_key :reading_positions, :books
  end
end
