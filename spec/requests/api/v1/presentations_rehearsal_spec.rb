require 'rails_helper'

RSpec.describe "Rehearsal API", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:presentation) { create(:presentation, group: group) }

  before { host! 'api.worshipgroupapp.com' }

  describe 'POST /groups/:group_id/presentations/:presentation_id/rehearsals' do
    before do
      post "/groups/#{group.id}/presentations/#{presentation.id}/rehearsals",
        params: rehearsal_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:rehearsal_params) { attributes_for(:rehearsal) }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        rehearsal = presentation.rehearsals.first
        expect(rehearsal).not_to be_nil
      end

      it "should return the presentation's rehearsal created" do
        expect(json_body.data).to respond_to(:id)
        expect(json_body.data).to respond_to(:date)
      end
    end
  end

  describe 'PUT /groups/:group_id/presentations/:presentation_id/rehearsals/:rehearsal_id' do
    let!(:rehearsal) { create(:rehearsal, presentation: presentation) }

    before do
      put "/groups/#{group.id}/presentations/#{presentation.id}/rehearsals/#{rehearsal.id}",
        params: rehearsal_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:rehearsal_params) { { date: 5.days.from_now.utc.iso8601 } }

      it { expect(response).to have_http_status(:ok) }

      it "should return the updated rehearsal" do
        expect(json_body.data.date).to eq(rehearsal_params[:date])
      end
    end
  end
end
