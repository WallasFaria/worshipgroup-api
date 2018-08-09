require 'rails_helper'

RSpec.describe "PresentationsSongs API", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }
  let(:groups_song) { create(:song, group: group) }
  let(:presentation) { create(:presentation, group: group) }

  describe 'POST /groups/:group_id/presentations/:presentation_id/songs' do
    before do
      post "/groups/#{group.id}/presentations/#{presentation.id}/songs",
        params: song_params.to_json, headers: headers
    end

    context 'when the params are valids' do
      let(:song_params) { attributes_for(:presentations_song, song_id: groups_song.id) }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        song = presentation.songs.where(song_id: groups_song.id).first
        expect(song).not_to be_nil
      end

      it "should return the presentation's song created" do
        expect(json_body.data).to respond_to(:id)
        expect(json_body.data).to respond_to(:name)
        expect(json_body.data).to respond_to(:artist)
        expect(json_body.data).to respond_to(:tone)
        expect(json_body.data).to respond_to(:url_youtube)
        expect(json_body.data).to respond_to(:url_cipher)
      end
    end
  end
end
