FactoryBot.define do
  factory :presentation do
    date { Faker::Time.between(Date.today, 10.days.from_now) }
    group

    trait :with_songs do
      transient { songs_count 5 }

      after(:create) do |presentation, evaluator|
        songs = create_list(:song, evaluator.songs_count, group: presentation.group)
        songs.each do |song|
          create(:presentations_song, presentation: presentation, song: song)
        end
      end
    end
  end
end
