# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
require "faker"

puts "Seeding default users..."

10.times do |index|
  email = "seed_user_#{index + 1}@example.com"

  User.find_or_create_by!(email: email) do |user|
    user.first_name = Faker::Name.first_name
    user.last_name = Faker::Name.last_name
    user.membership_number = format("M%04d", index + 1)
    user.phone = "555-000-#{format('%04d', index)}"
    user.home_church = "#{Faker::Address.city} Community Church"
    user.residence = Faker::Address.street_address
    user.city = Faker::Address.city
    user.date_of_birth = Faker::Date.birthday(min_age: 21, max_age: 65)
    user.password = "Password123!"
    user.password_confirmation = "Password123!"
  end
end

puts "Seeded #{User.where("email LIKE ?", "seed_user_%@example.com").count} users."
