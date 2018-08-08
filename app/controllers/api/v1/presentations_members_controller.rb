class Api::V1::PresentationsMembersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    member = current_group.members.find(params[:member_id])

    @presentations_member = current_presentation.members.create(member: member)

    if @presentations_member
      if params[:role_ids].present?
        @presentations_member.roles << params[:role_ids].map {|id| Role.find id }
      end

      render :show, status: :created
    end
  end

  def update
    @presentations_member = current_presentation.members.find params[:id]

    if params[:role_ids].present?
      @presentations_member.roles.destroy_all
      @presentations_member.roles << params[:role_ids].map {|id| Role.find id }
    end

    render :show, status: :ok
  end

  def destroy
    presentations_member = current_presentation.members.find(params[:id])
    current_presentation.members.destroy presentations_member
  end

  private

  def current_group
    @current_group ||= current_api_v1_user.groups.find(params[:group_id])
  end

  def current_presentation
    @current_presentation ||= current_group.presentations.find(params[:presentation_id])
  end
end
