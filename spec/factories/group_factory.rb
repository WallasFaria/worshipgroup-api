FactoryBot.define do
  factory :group do
    name { Faker::Lorem.unique.word }

    transient do
      member_admin :false
      collaborator_member :false
      default_member :false
    end

    after(:create) do |group, options|
      group.members.create(
        permission: :admin,
        user_id: options.member_admin
      ) if options.member_admin

      group.members.create(
        permission: :collaborator,
        user_id: options.collaborator_member
      ) if options.collaborator_member

      group.members.create(
        permission: :default,
        user_id: options.default_member
      ) if options.default_member
    end
  end
end
