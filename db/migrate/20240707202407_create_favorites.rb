class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites, id: :uuid do |t|
      t.uuid :user
      t.uuid :book

      t.timestamps
    end

    add_foreign_key :favorites, :users, column: :user_id, type: :uuid
    add_foreign_key :favorites, :books, column: :book_id, type: :uuid

    add_index :favorites, :user
    add_index :favorites, :book
  end
end
