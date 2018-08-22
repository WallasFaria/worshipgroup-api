FactoryBot.define do
  factory :rehearsal do
    date { Faker::Time.between(1.days.from_now, 9.days.from_now) }
    presentation
  end
end
