require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }

  describe "GET /groups" do
    let!(:groups) { create_list(:group, 3, user_id: @user.id) }
    before { get '/groups', headers: headers }

    it { expect(response).to have_http_status(:ok) }

    it 'should return a list of groups' do
      expect(json_body.data.size).to eq(3)
      expect(json_body.data.map(&:id)).to include(*groups.map(&:id))
    end
  end

  describe 'POST /groups' do
    before { post '/groups', params: group_params.to_json, headers: headers }

    context 'when the params are valids' do
      let(:group_params) { attributes_for(:group) }

      it { expect(response).to have_http_status(:created) }

      it 'should save the group in database' do
        expect(Group.find_by(name: group_params[:name])).not_to be_nil
      end

      it 'should return the json for created group' do
        expect(json_body.data.name).to eq(group_params[:name])
      end
    end

    context 'when the params are invalids' do
      let(:group_params) { attributes_for(:group, name: '') }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'does not save the group in the database' do
        expect(Group.find_by(name: group_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'GET /groups/:id' do
    let!(:group) { create(:group, user_id: @user.id) }

    context 'when the user is a member of the group' do
      before { get "/groups/#{group.id}", headers: headers }

      it { expect(response).to have_http_status(:ok) }

      it 'should return json for group' do
        expect(json_body.data.name).to eq(group.name)
      end

      it 'should return group members'
    end

    context 'when the user is not a member of the group' do
      it 'should return status code 403'
    end
  end

  describe 'PUT /groups/:id' do
    let!(:group) { create(:group, user_id: @user.id) }

    before do
      put "/groups/#{group.id}", params: group_params.to_json, headers: headers
    end

    context 'when the parms are valid' do
      let(:group_params) { { name: 'Nome alterado wf.worshipgroup' } }

      it { expect(response).to have_http_status(:ok) }

      it 'saves the group in database' do
        expect(Group.find_by(name: group_params[:name])).not_to be_nil
      end

      it 'return the json for updated group' do
        expect(json_body.data.name).to eq(group_params[:name])
      end
    end

    context 'when the parms are invalid' do
      let(:group_params) { { name: ' ' } }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'does not update the group in the database' do
        expect(Group.find_by(name: group_params[:name])).to be_nil
      end

      it 'returns the json errors for name' do
        expect(json_body.errors).to respond_to(:name)
      end
    end
  end

  describe 'DELETE /groups/:id' do
    let(:group) { create(:group, user_id: @user.id) }

    before { delete "/groups/#{group.id}", headers: headers }

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the group from the database' do
      expect{ Group.find group.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
