FactoryBot.define do
  factory :post do
    employee
    company
    store
    car_name
    car_type_id { 1 }
    genre
    title { Faker::Lorem.characters(number: 5) }
    caption { Faker::Lorem.characters(number: 20) }
  end
end
