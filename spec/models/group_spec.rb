require 'rails_helper'

RSpec.describe Group, type: :model do
  it { should respond_to(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }

  it 'validates max number of groups per user' do
    user = create(:user)
    create_list(:group, 5, user: user)
    group = Group.new(name: 'New Group', user: user)

    expect(group.valid?).to be_falsy
    expect(group.errors).to have_key(:user_id)
  end
end
