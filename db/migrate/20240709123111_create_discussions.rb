class CreateDiscussions < ActiveRecord::Migration[7.1]
  def change
    create_table :discussions, id: :uuid do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.uuid :book
      t.uuid :user

      t.timestamps
    end
    add_index :discussions, :book
    add_index :discussions, :user
  end
end
