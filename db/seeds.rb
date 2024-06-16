# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  email: 'admin@admin',
  password: 'testtest'
)

guest_company = Company.create!(
      email: 'guest_company@example.com',
      password: SecureRandom.urlsafe_base64,
      company_name: "株式会社ゲスト",
      company_name_kana: "カブシキガイシャゲスト",
      postal_code: "1111111",
      address: "ゲスト１−１−１",
      phone_number: "1111111111"
)

Genre.create!(
  company_id: guest_company.id,
  name: 'エンジン'
  )


