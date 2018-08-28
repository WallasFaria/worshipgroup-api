class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_group, only: [:show, :update, :destroy]

  def index
    @groups = current_api_v1_user.groups
  end

  def show
    @rules = Ability.new(current_api_v1_user, @group).to_list
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      @group.members.create(user_id: current_api_v1_user.id, permission: :admin)
      @rules = Ability.new(current_api_v1_user, @group).to_list
      render :show, status: :created, location: api_v1_group_url(@group)
    else
      render json: { errors: @group.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      @rules = Ability.new(current_api_v1_user, @group).to_list
      render :show, status: :ok, location: api_v1_group_url(@group)
    else
      render json: { errors: @group.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
  end

  private
    def set_group
      @group = current_api_v1_user.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
end
