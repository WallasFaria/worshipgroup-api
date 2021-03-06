require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  before { host! 'api.worshipgroup.test' }
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept': 'application/wf.worshipgroup.v1',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client']
    }
  end

  before { host! 'api.worshipgroupapp.com' }

  describe 'POST /auth/sign_in' do
    before do
      post '/auth/sign_in', params: credentials.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '12345678' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the authentication data in the headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid_password' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'retorns the json data for the errors' do
        expect(json_body).to respond_to(:errors)
      end
    end
  end

  describe 'DELETE /auth/sign_out' do
    before do
      delete "/auth/sign_out", headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'changes the user auth token' do
      user.reload
      expect(user.valid_token?(auth_data['access-token'], auth_data['client'])).to eq(false)
    end
  end
end
