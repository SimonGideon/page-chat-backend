class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities, id: :uuid do |t|
      t.string :country_code, null: false, limit: 2
      t.string :name, null: false
      t.string :state_province
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.integer :population
      t.timestamps
    end

    add_index :cities, :country_code
    add_index :cities, :name
    add_index :cities, [:country_code, :name]
    add_foreign_key :cities, :countries, column: :country_code, primary_key: :code
  end
end

