require 'rails_helper'

RSpec.describe "Api::V1::Members", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:another_user) { create(:random_user) }

  describe 'POST /groups/:group_id/members/' do
    before do
      post "/groups/#{group.id}/members", params: member_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:member_params) { { user_id: another_user.id, rule: :default } }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        member = Member.where(user_id: another_user.id).where(group_id: group.id)
        expect(member).not_to be_nil
      end

      it 'should return the json for created group' do
        expect(json_body.data.name).to eq(another_user.name)
      end
    end

    context 'when the params are invalids' do
      # let(:member_params) { { user_id: @user.id, rule: :default } }
    end
  end

end
