class AddAuthorToBooks < ActiveRecord::Migration[7.1]
  def change
    add_reference :books, :author, null: false, foreign_key: true, type: :uuid
  end
end
