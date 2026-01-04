class CreateLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :languages, id: false, primary_key: :code do |t|
      t.string :code, limit: 2, null: false, primary_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
