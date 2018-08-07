FactoryBot.define do
  factory :member do
    permission { %w(admin collaborator default)[rand 0..2] }
    group
    association :user, factory: :random_user
  end
end
