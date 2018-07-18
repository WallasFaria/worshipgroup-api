FactoryBot.define do
  factory :instrument do
    name { Faker::Lorem.word }
    icon { Faker::Internet.url }
  end
end
