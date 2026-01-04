class AddCountryAndCityReferencesToUsers < ActiveRecord::Migration[7.1]
  def up
    # Add new foreign key columns (nullable initially)
    add_column :users, :country_code, :string, limit: 2, null: true
    add_reference :users, :city, type: :uuid, foreign_key: true, null: true
    
    # Add foreign key for country_code
    add_foreign_key :users, :countries, column: :country_code, primary_key: :code
    
    # Migrate existing data: try to match country names to countries table
    # This is a best-effort migration - some might not match
    execute <<-SQL
      UPDATE users
      SET country_code = (
        SELECT code FROM countries
        WHERE LOWER(countries.name) = LOWER(users.country)
        LIMIT 1
      )
      WHERE country IS NOT NULL AND country != '';
    SQL
    
    # Migrate existing city data: try to match city names to cities table
    # This is more complex as we need to match by name and country
    execute <<-SQL
      UPDATE users
      SET city_id = (
        SELECT cities.id FROM cities
        WHERE LOWER(cities.name) = LOWER(users.city)
        AND cities.country_code = users.country_code
        LIMIT 1
      )
      WHERE city IS NOT NULL AND city != '' AND country_code IS NOT NULL;
    SQL
    
    # Remove old string columns after migration
    remove_column :users, :country, :string if column_exists?(:users, :country)
    remove_column :users, :city, :string if column_exists?(:users, :city)
    
    # Make the new columns required now that we've migrated the data
    change_column_null :users, :country_code, false
    change_column_null :users, :city_id, false
  end

  def down
    # Add back the old columns
    add_column :users, :country, :string, default: "", null: false unless column_exists?(:users, :country)
    add_column :users, :city, :string, null: false unless column_exists?(:users, :city)
    
    # Migrate data back from codes/IDs to names
    execute <<-SQL
      UPDATE users
      SET country = (SELECT name FROM countries WHERE countries.code = users.country_code)
      WHERE country_code IS NOT NULL;
    SQL
    
    execute <<-SQL
      UPDATE users
      SET city = (SELECT name FROM cities WHERE cities.id = users.city_id)
      WHERE city_id IS NOT NULL;
    SQL
    
    # Remove foreign key columns
    remove_foreign_key :users, :countries if foreign_key_exists?(:users, :countries)
    remove_column :users, :country_code, :string if column_exists?(:users, :country_code)
    remove_reference :users, :city, foreign_key: true if column_exists?(:users, :city_id)
  end
end

