require 'rails_helper'

RSpec.describe 'Instruments API', type: :request do
  include HeaderSupport
  let(:headers) { headers_with_auth }

  before { host! 'api.worshipgroup.test' }
  let!(:instruments) { create_list :instrument, 10 }

  describe 'GET /instruments' do
    before do
      get '/instruments', headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 10 instruments' do
      expect(json_body.data.size).to eq instruments.size
    end

    it 'returns a list with name and icon attributes' do
      expect(json_body.data[2].name).to eq instruments[2].name
      expect(json_body.data[2].icon).to start_with 'http'
      expect(json_body.data[2].icon).to include instruments[2].icon
    end
  end
end
