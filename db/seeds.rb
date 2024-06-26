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

genre_names = [
  'エンジン',
  'ミッション',
  '足廻り',
  '電装品',
  '用品取付',
  '作業ミス'
]

genre_names.each do |name|
  Genre.create!(
    company_id: guest_company.id,
    name: name
  )
end

tasks = [
  { name: '事前準備', body: '翌日作業予定は確認したか？' },
  { name: '部品', body: '翌日作業予定の部品は揃っているか？また直近（２〜３日以内）で担当整備の部品は届いているか？' },
  { name: '整備歴', body: '翌日作業予定の整備歴は確認したか？' },
  { name: '工具', body: '作業するための工具はあるか？' },
  { name: '整理整頓', body: '作業後・終業時に工具は元の位置に戻したか？' },
  { name: '美化', body: '工場床にオイルなどの汚れや部品、工具など落ちてないか？' }
]

tasks.each do |task_params|
  Task.create!(
    company_id: guest_company.id,
    name: task_params[:name],
    body: task_params[:body]
  )
end

car_names = [
  {name: 'F○T', car_type: 'DBA-GE○'},
  {name: 'FR○○D', car_type: 'DBA-GB○'}
  ]

car_names.each do |car_name_params|
  CarName.create!(
    company_id: guest_company.id,
    name: car_name_params[:name],
    car_type: car_name_params[:car_type]
  )
end

Store.create!(
  company_id: guest_company.id,
  name: 'ゲスト'
  )


Employee.create!(
  company_id: guest_company.id,
  store_id: guest_company.id,
  email: 'guest_employee@example.com',
  password: SecureRandom.urlsafe_base64,
  last_name: '車',
  first_name: '太郎',
  last_name_kana: 'クルマ',
  first_name_kana: 'タロウ'
  )

