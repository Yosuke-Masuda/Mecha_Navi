FactoryBot.define do
  factory :company do
    company_name { Faker::Lorem.characters(number: 10) }
    company_name_kana { Faker::Lorem.characters(number: 10) }
    postal_code { Faker::Address.zip_code }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    phone_number { Faker::PhoneNumber.phone_number }
    is_active { true }
  end
end