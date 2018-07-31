class Api::V1::MembersController < ApplicationController
  before_action :set_group

  def create
    @member = @group.members.new(member_params)

    if @member.save
      render :show, status: :created
    else
      render json: { errors: @member.errors }, status: :unprocessable_entity
    end
  end

  def update
    @member = @group.members.find(params[:id])

    if @member.update(permission: member_params[:permission])
      render :show, status: :ok
    else
      render json: { errors: @member.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @group.members.find(params[:id]).destroy
  end

  private

  def set_group
    @group = current_api_v1_user.groups.find(params[:group_id])
  end

  def member_params
    params.require(:member).permit(:user_id, :permission)
  end
end
