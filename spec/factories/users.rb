FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    gender { %w[female male non_binary unspecified].sample }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    jti { SecureRandom.uuid }
  end
end
