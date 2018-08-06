FactoryBot.define do
  factory :presentations_song do
    tone { ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#'][rand(0..9)] }
    presentation
    song
  end
end
