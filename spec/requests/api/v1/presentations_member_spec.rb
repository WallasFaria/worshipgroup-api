require 'rails_helper'

RSpec.describe "PresentationsMembers API", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:groups_member) { create(:member, group: group) }
  let(:presentation) { create(:presentation, group: group) }

  describe 'POST /groups/:group_id/presentations/:presentation_id/members' do
    before do
      post "/groups/#{group.id}/presentations/#{presentation.id}/members",
        params: member_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:member_params) { { member_id: groups_member.id, role_ids: [create(:role).id] } }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        member = presentation.members.where(member_id: groups_member.id).first
        expect(member).not_to be_nil
      end

      it "should return presentarion's member with roles" do
        expect(json_body.data).to respond_to(:id)
        expect(json_body.data).to respond_to(:name)
        expect(json_body.data).to respond_to(:roles)

        a_role = json_body.data.roles.first
        expect(a_role).to respond_to(:id)
        expect(a_role).to respond_to(:name)
        expect(a_role).to respond_to(:icon)
      end
    end
  end
end
