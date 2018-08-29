require 'rails_helper'

RSpec.describe "Api::V1::Members", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:another_user) { create(:random_user) }

  before { host! 'api.worshipgroupapp.com' }

  describe 'POST /groups/:group_id/members/' do
    before do
      post "/groups/#{group.id}/members", params: member_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:member_params) { { user_id: another_user.id, permission: :default } }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        member = Member.where(user_id: another_user.id).where(group_id: group.id).first
        expect(member).not_to be_nil
      end

      it 'should return the json for created group' do
        expect(json_body.data.name).to eq(another_user.name)
      end
    end

    context 'when the user is not an admin member' do
      let(:member_params) { { user_id: another_user.id, permission: :default } }
      let(:group) { create(:group, default_member: @user.id) }

      it { expect(response).to have_http_status(403) }
    end
  end

  describe 'PUT /groups/:group_id/members/:id' do
    let(:member) { group.members.create(user: another_user, permission: :default) }
    before { put "/groups/#{group.id}/members/#{member.id}",
                 params: { permission: :admin }.to_json,
                 headers: headers }

    it 'should return the updated member data' do
      expect(json_body.data.permission).to eq('admin')
    end
  end

  describe 'DELETE /groups/:group_id/members/:id' do
    let(:member) { group.members.create(user: another_user, permission: :default) }
    before { delete "/groups/#{group.id}/members/#{member.id}", headers: headers }

    it { expect(response).to have_http_status(204) }

    it 'should remove the group member' do
      expect(Member.find_by(id: member.id)).to be_nil
    end

    context 'when the user is not an admin member' do
      let(:group) { create(:group, default_member: @user.id) }

      it { expect(response).to have_http_status(403) }

      context 'remove yourself' do
        let(:member) { group.get_member_to(@user) }

        it { expect(response).to have_http_status(204) }

        it 'should remove the group member' do
          expect(Member.find_by(id: member.id)).to be_nil
        end
      end
    end
  end
end
