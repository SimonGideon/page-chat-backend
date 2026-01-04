class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries, id: false do |t|
      t.string :code, null: false, limit: 2, primary_key: true
      t.string :name, null: false
      t.string :iso3, limit: 3
      t.string :numeric_code, limit: 3
      t.string :capital
      t.string :currency_code, limit: 3
      t.string :phone_code
      t.timestamps
    end

    add_index :countries, :name
  end
end

