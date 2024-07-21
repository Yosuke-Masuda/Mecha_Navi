FactoryBot.define do
  factory :employee do
    transient do
      person { Gimei.name }
    end
    last_name { person.last.kanji }
    first_name { person.first.kanji }
    last_name_kana { person.last.katakana }
    first_name_kana { person.first.katakana }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    is_active { true }
    company
    store
  end
end