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

    trait :with_members do
      transient do
        members_count 4
      end

      after(:create) do |presentation, evaluator|
        members = create_list(:member, evaluator.members_count, group: presentation.group)
        members.each do |member|
          create(:presentations_member, presentation: presentation, member: member)
        end
      end
    end

    trait :with_rehearsals do
      transient { rehearsals_count 1 }

      after(:create) do |presentation, evaluator|
        create_list(:rehearsal, evaluator.rehearsals_count, presentation: presentation)
      end
    end
  end
end
