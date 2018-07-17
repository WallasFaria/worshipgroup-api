FactoryBot.define do
  factory :user do
    name 'Fulano'
    email 'fulano@email.com'
    password '12345678'
    telephone '+5522997465312'
    date_of_birth '1992-07-22'
  end

  factory :random_user, class: :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    telephone { Faker::PhoneNumber.cell_phone }
    date_of_birth { Faker::Date.birthday(18, 40).strftime('%Y-%m-%d') }
  end
end
