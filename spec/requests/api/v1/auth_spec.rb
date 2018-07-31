require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
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

  before { host! 'api.worshipgroup.test' }

  describe 'GET /auth/validate_token' do
    context 'when the request headers are valid' do
      before do
        get '/auth/validate_token', headers: headers
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user' do
        expect(json_body.data.id.to_i).to eq user.id
      end
    end

    context 'when the request headers are not valid' do
      before do
        headers['access-token'] = 'invalid_token'
        get '/auth/validate_token', headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /auth' do
    before do
      post '/auth', headers: headers, params: user_params.to_json
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for :random_user }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for created user' do
        expect(json_body.data.email).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:random_user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for the errors' do
        expect(json_body).to respond_to(:errors)
      end
    end
  end

  describe 'PUT /auth' do
    before do
      put "/auth", params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) do
        {
          name: 'Fulano Songinthechurch',
          telephone: '+5522997465864',
          date_of_birth: '1988-06-26'
        }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for updated user' do
        expect(json_body.data.name).to eq(user_params[:name])
        expect(json_body.data.telephone).to eq(user_params[:telephone])
        expect(json_body.data.date_of_birth).to eq(user_params[:date_of_birth])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid_email@' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for the errors' do
        expect(json_body).to respond_to(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before do
      delete '/auth', headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'removes the user from database' do
      expect( User.find_by(id: user.id) ).to be_nil
    end
  end
end
