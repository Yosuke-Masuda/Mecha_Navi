FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    body { Faker::Lorem.characters(number: 20) }
    company
  end
end
