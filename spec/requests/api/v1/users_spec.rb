require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }

  before { host! 'api.worshipgroupapp.com' }

  describe 'POST /profile/roles' do
    let!(:roles) { create_list(:role, 3) }

    before { post '/profile/roles', headers: headers, params: { role_ids: ids }.to_json }

    context 'when the request params are valid' do
      let(:ids) { roles.map(&:id) }

      it { expect(response).to have_http_status(:created) }

      it 'returns json data from the user with the added roles' do
        expect(json_body.data.roles.map(&:name)).to include(*roles.map(&:name))
      end
    end
  end

  describe 'DELETE /profile/roles/:id' do
    let!(:roles) { @user.roles << create_list(:role, 3) }
    let(:role_id) { roles.first.id }

    before { delete "/profile/roles/#{role_id}", headers: headers }

    it { expect(response).to have_http_status(204) }

    it 'should disassociate user role in database' do
      expect(@user.roles.find_by(id: role_id)).to be_nil
    end
  end
end
