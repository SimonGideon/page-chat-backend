class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments, id: :uuid do |t|
      t.uuid :discussion
      t.uuid :user
      t.text :body

      t.timestamps
    end
    add_index :comments, :discussion
    add_index :comments, :user
  end
end
