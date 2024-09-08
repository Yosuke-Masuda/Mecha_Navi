FactoryBot.define do
  factory :genre do
    company
    name { Faker::Name.name }
    is_active { [true, false] }
  end
end
