require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do
  include HeaderSupport
  let!(:headers) { headers_with_auth }

  before { host! 'api.worshipgroupapp.com' }

  describe "GET /groups" do
    let!(:groups) { create_list(:group, 3, member_admin: @user.id ) }
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

      it 'should adds the current user with group member' do
        expect(json_body.data.members.map(&:user_id)).to include(@user.id)
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
    let!(:another_user) { create(:random_user) }

    context 'when the user is a member of the group' do
      before do
        group.members.create(user: another_user, permission: :default)
        get "/groups/#{group.id}", headers: headers
      end

      context 'with admin permission' do
        let!(:group) { create(:group, member_admin: @user.id) }

        it { expect(response).to have_http_status(:ok) }

        it 'should return json for group' do
          expect(json_body.data.name).to eq(group.name)
        end

        it 'should return group members' do
          member_names = [@user.name, another_user.name]
          expect(json_body.data.members.map(&:name)).to eq(member_names)
        end

        it 'should return the admin rules' do
          admin_rules = [
            {
              actions: ['manager'],
              subject: ['all']
            }
          ]

          expect(body_as_hash[:data][:rules]).to eq(admin_rules)
        end
      end

      context 'with collaborator permission' do
        let!(:group) { create(:group, collaborator_member: @user.id) }

        it 'should return the collaborator rules' do
          collaborator_rules = [
            {
              actions: ['read'],
              subject: ['all']
            },
            {
              actions: ['read', 'create'],
              subject: ['Song']
            },
            {
              actions: ['manage'],
              subject: ['PresentationsSong'],
            },
            {
              actions: ['destroy'],
              subject: ['Member'],
              conditions: {
                user_id: @user.id
              }
            }
          ]

          expect(body_as_hash[:data][:rules]).to eq(collaborator_rules)
        end
      end

      context 'with default permission' do
        let!(:group) { create(:group, default_member: @user.id) }

        it 'should return the default rules' do
          default_rules = [
            {
              actions: ['read'],
              subject: ['all']
            },
            {
              actions: ['destroy'],
              subject: ['Member'],
              conditions: {
                user_id: @user.id
              }
            }
          ]

          expect(body_as_hash[:data][:rules]).to eq(default_rules)
        end
      end
    end

    context 'when the user is not a member of the group' do
      let!(:group) { create(:group, member_admin: another_user.id) }

      it 'shoul return ActiveRecord Not Found error' do
        expect { get "/groups/#{group.id}", headers: headers }
        .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT /groups/:id' do
    let!(:group) { create(:group, member_admin: @user.id) }

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
    let(:group) { create(:group, member_admin: @user.id) }

    before { delete "/groups/#{group.id}", headers: headers }

    it { expect(response).to have_http_status(:no_content) }

    it 'removes the group from the database' do
      expect{ Group.find group.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
