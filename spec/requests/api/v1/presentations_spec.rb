require 'rails_helper'

RSpec.describe "Presentations API", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:another_user) { create(:random_user) }

  before { host! 'api.worshipgroupapp.com' }

  describe 'POST /groups/:group_id/presentations/' do
    before do
      post "/groups/#{group.id}/presentations", params: presentation_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:presentation_params) { { date: Time.zone.now.utc.iso8601, group_id: group.id } }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        presentation = Presentation.where(presentation_params).first
        expect(presentation).not_to be_nil
      end

      it 'should return the json for created group' do
        expect(json_body.data.date.to_time).to eq(presentation_params[:date].to_time)
        expect(json_body.data).to respond_to(:description)
      end
    end

    context 'when the params are invalids' do
      let(:presentation_params) { { date: 'invalid value', group_id: group.id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'should not save the group in database' do
        presentation = Presentation.where(presentation_params).first
        expect(presentation).to be_nil
      end

      it 'should return the erros key' do
        expect(json_body).to respond_to :errors
      end
    end
  end

  describe 'PUT /groups/:group_id/presentations/:id' do
    let(:presentation) { group.presentations.create({ date: Time.zone.now.utc.iso8601 }) }
    let(:date) { 1.day.from_now.utc.iso8601 }
    before { put "/groups/#{group.id}/presentations/#{presentation.id}",
                 params: { date: date }.to_json,
                 headers: headers }

    it 'should return the updated presentation data' do
      expect(json_body.data.date.to_time).to eq(date.to_time)
    end
  end

  describe '/groups/:group_id/presentations' do
    let!(:presentations) { create_list(:presentation, 2, :with_songs, :with_members, group: group) }
    before { get "/groups/#{group.id}/presentations", headers: headers }

    it { expect(response).to have_http_status :ok }

    it 'returns presentations array with songs' do
      presentation = json_body.data.first
      expect(presentation).to respond_to(:songs)

      a_song = presentation.songs.first
      expect(a_song).to respond_to(:id)
      expect(a_song).to respond_to(:name)
      expect(a_song).to respond_to(:artist)
      expect(a_song).to respond_to(:tone)
      expect(a_song).to respond_to(:url_youtube)
      expect(a_song).to respond_to(:url_cipher)
    end

    it 'returns presentations array with members' do
      presentation = json_body.data.first
      expect(presentation).to respond_to(:members)

      a_member = presentation.members.first
      expect(a_member).to respond_to(:id)
      expect(a_member).to respond_to(:name)
    end
  end

  describe 'DELETE /groups/:group_id/presentations/:id' do
    let(:presentation) { group.presentations.create({ date: Time.now }) }
    before { delete "/groups/#{group.id}/presentations/#{presentation.id}", headers: headers }

    it { expect(response).to have_http_status(204) }

    it 'should remove the group presentation' do
      expect(Presentation.find_by(id: presentation.id)).to be_nil
    end
  end
end
