class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :biography, null: true
      t.string :website, null: true
      t.string :social_handle, null: true
      t.timestamps
    end
    add_index :authors, :id
    add_reference :books, :author, type: :uuid, foreign_key: true
  end
end
