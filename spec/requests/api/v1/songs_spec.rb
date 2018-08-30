require 'rails_helper'

RSpec.describe "Api::V1::Songs", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, member_admin: @user.id) }

  before { host! 'api.worshipgroupapp.com' }

  describe "GET /groups/:group_id/songs" do
    context 'when filter params is not send' do
      let!(:songs) { create_list :song, 30, group_id: group.id }
      before { get "/groups/#{group.id}/songs", headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns songs list with pagination' do
        expect(json_body.data.size).to eq 10
        expect(json_body).to respond_to :links
      end

      it 'navegates to next page' do
        get json_body.links.next, headers: headers
        body = JSON.parse(response.body)

        expect(body['data'][0]['id']).to eq(songs[10].id)
      end

      it 'returns only songs from the informed group' do
        expected = []
        json_body.data.size.times { expected << group.id }
        expect(json_body.data.map(&:group_id)).to eq(expected)
      end
    end

    context 'when filter and sorting params are send' do
      let!(:good_song_1) { create(:song, name: 'A good song', group_id: group.id) }
      let!(:good_song_2) { create(:song, name: 'Another good song', group_id: group.id) }
      let!(:excelent_song_1) { create(:song, name: 'A great song', group_id: group.id) }
      let!(:excelent_song_2) { create(:song, name: 'Another great song', group_id: group.id) }

      before do
        get "/groups/#{group.id}/songs?q[name_cont_all]=good&q[name_cont_any]=song&q[s]=name+DESC", headers: headers
      end

      it 'returns only the songs matching' do
        returned_song_names = json_body.data.map{ |m| m.name }

        expect(returned_song_names).to eq([good_song_2.name, good_song_1.name])
      end
    end
  end

  describe 'GET /groups/:group_id/song/:id' do
    let(:song) { create(:song, group_id: group.id) }

    before do
      get "/groups/#{group.id}/songs/#{song.id}", headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status 200
    end

    it 'returns the json for song' do
      expect(json_body.data.name).to eq(song.name)
      expect(json_body.data.artist).to eq(song.artist)
      expect(json_body.data.url_youtube).to eq(song.url_youtube)
      expect(json_body.data.url_cipher).to eq(song.url_cipher)
    end
  end

  describe 'POST /groups/:group_id/songs' do
    before do
      post "/groups/#{group.id}/songs", params: song_params.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:song_params) { attributes_for(:song) }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'saves the song in database' do
        expect(Song.find_by(name: song_params[:name])).not_to be_nil
      end

      it 'return the json for created song' do
        expect(json_body.data.name).to eq(song_params[:name])
      end

      it 'associates the song with the informed group' do
        expect(json_body.data.group_id).to eq(group.id)
      end
    end

    context 'when the params are invalid' do
      let(:song_params) { attributes_for(:song, name: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not save the song in the database' do
        expect(Song.find_by(name: song_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'PUT /groups/:group_id/songs/:id' do
    let!(:song) { create(:song, group_id: group.id) }

    before do
      put "/groups/#{group.id}/songs/#{song.id}", params: song_params.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:song_params) { { name: 'Nome alterado wf.worshipgroup' } }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'saves the song in database' do
        expect(Song.find_by(name: song_params[:name])).not_to be_nil
      end

      it 'return the json for updated song' do
        expect(json_body.data.name).to eq(song_params[:name])
      end
    end

    context 'when the params are invalid' do
      let(:song_params) { { name: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not update the song in the database' do
        expect(Song.find_by(name: song_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'DELETE /groups/:group_id/songs/:id' do
    let(:song) { create(:song, group_id: group.id) }

    before do
      delete "/groups/#{group.id}/songs/#{song.id}", headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

    it 'removes the song from the database' do
      expect{ Song.find song.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when the user is not an admin member' do
      let(:group) { create(:group, default_member: @user.id) }

      it { expect(response).to have_http_status(403) }
    end
  end
end
