require 'rails_helper'

RSpec.describe 'Roles API', type: :request do
  include HeaderSupport
  let(:headers) { headers_with_auth }

  before { host! 'api.worshipgroupapp.com' }
  let!(:roles) { create_list :role, 10 }

  describe 'GET /roles' do
    before do
      get '/roles', headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 10 roles' do
      expect(json_body.data.size).to eq roles.size
    end

    it 'returns a list with name and icon attributes' do
      expect(json_body.data[2].name).to eq roles[2].name
      expect(json_body.data[2].icon).to start_with 'http'
      expect(json_body.data[2].icon).to include roles[2].icon
    end
  end
end
