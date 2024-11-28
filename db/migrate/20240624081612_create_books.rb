class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :language, null: false
      t.string :edition, null: true
      t.string :publisher, null: true
      t.integer :page_count, null: false
      t.date :published_at, null: false
      t.string :isbn, null: true
      t.boolean :featured, null: false, default: false

      t.timestamps
    end

    add_index :books, :title, unique: true
  end
end
