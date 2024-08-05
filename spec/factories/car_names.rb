FactoryBot.define do
  factory :car_name do
    company
    name { Faker::Name.name }
    car_type { Faker::Lorem.characters(number: 10) }
    is_active { [true, false] }
  end
end