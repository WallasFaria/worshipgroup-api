FactoryBot.define do
  factory :group do
    name { Faker::Lorem.unique.word }

    transient do
      member_admin :false
    end

    after(:create) do |group, options|
      group.members.create(
        permission: :admin,
        user_id: options.member_admin
      ) if options.member_admin
    end
  end
end
