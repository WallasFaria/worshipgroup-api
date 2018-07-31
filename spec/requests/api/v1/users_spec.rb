require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }

  before { host! 'api.worshipgroup.test' }

  describe 'POST /users/me/instruments' do
    let!(:instruments) { create_list(:instrument, 3) }

    before { post '/users/me/instruments', headers: headers, params: { instrument_ids: ids }.to_json }

    context 'when the request params are valid' do
      let(:ids) { instruments.map(&:id) }

      it { expect(response).to have_http_status(:created) }

      it 'returns json data from the user with the added instruments' do
        expect(json_body.data.instruments.map(&:name)).to include(*instruments.map(&:name))
      end
    end
  end
end
