class CreateJoinTablePresentationsMemberRoles < ActiveRecord::Migration[5.2]
  def change
    create_join_table :presentations_members, :roles do |t|
      t.index [:presentations_member_id, :role_id], unique: true,
        name: :index_presentations_members_roles
    end
  end
end
