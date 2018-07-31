FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }
    icon { Faker::Internet.url }
  end
end
