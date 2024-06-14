# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    membership_number { Faker::Number.unique.number(digits: 6).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    home_church { Faker::Company.name }
    residence { Faker::Address.street_address }
    city { Faker::Address.city }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    jti { SecureRandom.uuid }
  end
end
