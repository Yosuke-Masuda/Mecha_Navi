FactoryBot.define do
  factory :company do
    company_name { Faker::Company.name[0, rand(3..10)] }
    company_name_kana { Gimei.last.katakana[0, rand(3..10)] }
    postal_code { 7.times.map { rand(0..9) }.join("") }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    phone_number { Faker::PhoneNumber.phone_number }
    is_active { true }
  end
end
