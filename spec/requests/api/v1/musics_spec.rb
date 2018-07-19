require 'rails_helper'

RSpec.describe "Api::V1::Musics", type: :request do
  before { host! 'api.worshipgroup.test' }
  let!(:user) { create :user }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept': 'application/wf.worshipgroup.v1',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client'],
    }
  end

  describe "GET /musics" do
    context 'when filter params is not send' do
      let!(:musics) { create_list :music, 30 }
      before { get '/musics', headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns musics list with pagination' do
        expect(json_body[:data].size).to eq 10
        expect(json_body).to have_key :links
      end

      it 'navegates to next page' do
        get json_body[:links][:next], headers: headers
        body = JSON.parse(response.body)

        expect(body['data'][0]['id']).to eq(musics[10].id)
      end
    end

    context 'when filter and sorting params are send' do
      let!(:good_music_1) { create(:music, name: 'A good song') }
      let!(:good_music_2) { create(:music, name: 'Another good song') }
      let!(:excelent_music_1) { create(:music, name: 'A great song') }
      let!(:excelent_music_2) { create(:music, name: 'Another great song') }

      before do
        get '/musics?q[name_cont_all]=good&q[name_cont_any]=song&q[s]=name+DESC', headers: headers
      end

      it 'returns only the musics matching' do
        returned_music_names = json_body[:data].map{ |m| m[:name] }

        expect(returned_music_names).to eq([good_music_2.name, good_music_1.name])
      end
    end
  end

  describe 'GET /music/:id' do
    let(:music) { create(:music) }

    before do
      get "/musics/#{music.id}", headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status 200
    end

    it 'returns the json for music' do
      expect(json_body[:data][:name]).to eq(music.name)
      expect(json_body[:data][:artist]).to eq(music.artist)
      expect(json_body[:data][:url_youtube]).to eq(music.url_youtube)
      expect(json_body[:data][:url_cipher]).to eq(music.url_cipher)
    end
  end

  describe 'POST /musics' do
    before do
      post '/musics', params: music_params.to_json, headers: headers
    end

    context 'when the parms are valid' do
      let(:music_params) { attributes_for(:music) }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'saves the music in database' do
        expect(Music.find_by(name: music_params[:name])).not_to be_nil
      end

      it 'return the json for created music' do
        expect(json_body[:data][:name]).to eq(music_params[:name])
      end
    end

    context 'when the parms are invalid' do
      let(:music_params) { attributes_for(:music, name: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not save the music in the database' do
        expect(Music.find_by(name: music_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /musics/:id' do
    let!(:music) { create(:music) }

    before do
      put "/musics/#{music.id}", params: music_params.to_json, headers: headers
    end

    context 'when the parms are valid' do
      let(:music_params) { { name: 'Nome alterado wf.worshipgroup' } }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'saves the music in database' do
        expect(Music.find_by(name: music_params[:name])).not_to be_nil
      end

      it 'return the json for updated music' do
        expect(json_body[:data][:name]).to eq(music_params[:name])
      end
    end

    context 'when the parms are invalid' do
      let(:music_params) { { name: ' ' } }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'does not update the music in the database' do
        expect(Music.find_by(name: music_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'DELETE /musics/:id' do
    let(:music) { create(:music) }

    before do
      delete "/musics/#{music.id}", headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

    it 'removes the music from the database' do
      expect{ Music.find music.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
