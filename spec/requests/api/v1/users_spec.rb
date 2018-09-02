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

  describe 'GET /users' do
    let!(:user1) { create(:random_user, name: 'Diogo Lacerda',
                                        email: 'giogolacerda@hotmail.ccom',
                                        telephone: '+5522999887766') }

    let!(:user2) { create(:random_user, name: 'Valentina Vieira',
                                        email: 'valentina.vieira@yahoo.ccom',
                                        telephone: '+5543981883366') }

    let!(:user3) { create(:random_user, name: 'Diogo Stark',
                                        email: 'victorstark01@gmail.ccom',
                                        telephone: '+130133004499') }

    before { get "/users", params: { q: query }, headers: headers }

    context 'not filters' do
      let(:query) { '' }

      it { expect(response).to have_http_status(:ok) }

      it 'returns a empty list' do
        expect(body_as_hash[:data]).to eq([])
      end
    end

    context 'filter by email' do
      let(:query) { user1.email }

      it { expect(response).to have_http_status(:ok) }

      it 'returns list with id, name and roles' do
        expected = [{ id: user1.id, name: user1.name, roles: [] }]
        expect(body_as_hash[:data]).to eq(expected)
      end
    end

    context 'filter by telephone' do
      let(:query) { user2.telephone }

      it 'returns list with id, name and roles' do
        expected = [{ id: user2.id, name: user2.name, roles: [] }]
        expect(body_as_hash[:data]).to eq(expected)
      end
    end

    context 'filter by name' do
      let(:query) { 'Diogo' }

      it 'returns list with id, name and roles' do
        expected = ['Diogo Lacerda', 'Diogo Stark']
        expect(json_body.data.size).to eq(expected.size)
        expect(json_body.data.map(&:name)).to include(*expected)
      end
    end
  end
end
