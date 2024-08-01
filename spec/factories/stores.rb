FactoryBot.define do
  factory :store do
    name { Faker::Name.name }
    is_active { [true, false] }
    company
  end
end