FactoryBot.define do
  factory :song do
    name { Faker::Lorem.word }
    artist { Faker::Name.name }
    url_youtube { Faker::Internet.url }
    url_cipher { Faker::Internet.url }
  end
end
