class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :book_id, null: false

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :book_id

    add_foreign_key :favorites, :users, column: :user_id
    add_foreign_key :favorites, :books, column: :book_id
  end
end
