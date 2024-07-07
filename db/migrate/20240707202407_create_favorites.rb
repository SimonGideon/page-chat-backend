class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites, id: :uuid do |t|
      t.uuid :user
      t.uuid :book

      t.timestamps
    end

    add_reference :users, :favorites, type: :uuid, foreign_key: true
    add_reference :books, :favorites, type: :uuid, foreign_key: true

    add_index :favorites, :user
    add_index :favorites, :book
  end
end
