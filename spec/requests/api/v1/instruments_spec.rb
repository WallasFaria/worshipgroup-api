require 'rails_helper'

RSpec.describe 'Instruments API', type: :request do
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
  let!(:users) { create_list :instrument, 10 }

  describe 'GET /instruments' do
    before do
      get '/instruments', headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 10 instruments' do
      expect(json_body.data.size).to eq users.size
    end

    it 'returns a list with name and icon attributes' do
      expect(json_body.data[2].name).to eq users[2].name
      expect(json_body.data[2].icon).to start_with 'http'
      expect(json_body.data[2].icon).to include users[2].icon
    end
  end
end
