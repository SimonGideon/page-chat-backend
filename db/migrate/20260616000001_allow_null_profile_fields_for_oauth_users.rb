class AllowNullProfileFieldsForOauthUsers < ActiveRecord::Migration[7.1]
  def change
    # OAuth users sign up with only Google profile data.
    # Phone, address, location, and DOB are collected later on /complete-profile.
    change_column_null :users, :phone, true
    change_column_null :users, :address, true
    change_column_null :users, :date_of_birth, true
    change_column_null :users, :country_code, true
    change_column_null :users, :city_id, true
    change_column_default :users, :address, from: "", to: nil
  end
end
