class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :categories, :id
    add_reference :books, :category, type: :uuid, foreign_key: true
  end
end
