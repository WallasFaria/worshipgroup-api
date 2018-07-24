require 'rails_helper'

RSpec.describe "Api::V1::Musics", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }
  let(:group) { create(:group, user_id: @user.id) }

  before { host! 'api.worshipgroup.test' }

  describe "GET /groups/:group_id/musics" do
    context 'when filter params is not send' do
      let!(:musics) { create_list :music, 30, group_id: group.id }
      before { get "/groups/#{group.id}/musics", headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns musics list with pagination' do
        expect(json_body.data.size).to eq 10
        expect(json_body).to respond_to :links
      end

      it 'navegates to next page' do
        get json_body.links.next, headers: headers
        body = JSON.parse(response.body)

        expect(body['data'][0]['id']).to eq(musics[10].id)
      end

      it 'returns only musics from the informed group' do
        expected = []
        json_body.data.size.times { expected << group.id }
        expect(json_body.data.map(&:group_id)).to eq(expected)
      end
    end

    context 'when filter and sorting params are send' do
      let!(:good_music_1) { create(:music, name: 'A good song', group_id: group.id) }
      let!(:good_music_2) { create(:music, name: 'Another good song', group_id: group.id) }
      let!(:excelent_music_1) { create(:music, name: 'A great song', group_id: group.id) }
      let!(:excelent_music_2) { create(:music, name: 'Another great song', group_id: group.id) }

      before do
        get "/groups/#{group.id}/musics?q[name_cont_all]=good&q[name_cont_any]=song&q[s]=name+DESC", headers: headers
      end

      it 'returns only the musics matching' do
        returned_music_names = json_body.data.map{ |m| m.name }

        expect(returned_music_names).to eq([good_music_2.name, good_music_1.name])
      end
    end
  end

  describe 'GET /groups/:group_id/music/:id' do
    let(:music) { create(:music, group_id: group.id) }

    before do
      get "/groups/#{group.id}/musics/#{music.id}", headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status 200
    end

    it 'returns the json for music' do
      expect(json_body.data.name).to eq(music.name)
      expect(json_body.data.artist).to eq(music.artist)
      expect(json_body.data.url_youtube).to eq(music.url_youtube)
      expect(json_body.data.url_cipher).to eq(music.url_cipher)
    end
  end

  describe 'POST /groups/:group_id/musics' do
    before do
      post "/groups/#{group.id}/musics", params: music_params.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:music_params) { attributes_for(:music) }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'saves the music in database' do
        expect(Music.find_by(name: music_params[:name])).not_to be_nil
      end

      it 'return the json for created music' do
        expect(json_body.data.name).to eq(music_params[:name])
      end

      it 'associates the music with the informed group' do
        expect(json_body.data.group_id).to eq(group.id)
      end
    end

    context 'when the params are invalid' do
      let(:music_params) { attributes_for(:music, name: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not save the music in the database' do
        expect(Music.find_by(name: music_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'PUT /groups/:group_id/musics/:id' do
    let!(:music) { create(:music, group_id: group.id) }

    before do
      put "/groups/#{group.id}/musics/#{music.id}", params: music_params.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:music_params) { { name: 'Nome alterado wf.worshipgroup' } }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'saves the music in database' do
        expect(Music.find_by(name: music_params[:name])).not_to be_nil
      end

      it 'return the json for updated music' do
        expect(json_body.data.name).to eq(music_params[:name])
      end
    end

    context 'when the params are invalid' do
      let(:music_params) { { name: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not update the music in the database' do
        expect(Music.find_by(name: music_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'DELETE /groups/:group_id/musics/:id' do
    let(:music) { create(:music, group_id: group.id) }

    before do
      delete "/groups/#{group.id}/musics/#{music.id}", headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

    it 'removes the music from the database' do
      expect{ Music.find music.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
