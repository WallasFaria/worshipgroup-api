require 'rails_helper'

RSpec.describe User, type: :model do

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :telephone }
  it { should respond_to :date_of_birth }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :date_of_birth }

  # it { should validate_uniqueness_of(:email).case_insensitive }

  describe '#is_an_admin_member?' do
    let!(:user) { create(:random_user) }

    context "when the user is an admin" do
      it 'should be true' do
        group = create(:group, member_admin: user.id)
        expect(user.is_an_admin_member? group).to be_truthy
      end
    end

    context "when the user is not an admin" do
      it 'should be false' do
        group = create(:group)
        expect(user.is_an_admin_member? group).to be_falsey
      end
    end
  end

end
