class Api::V1::GroupAbilitiesController < ApplicationController
  include CanCan::ControllerAdditions

  before_action :authenticate_api_v1_user!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end

  private

  def current_user
    current_api_v1_user
  end

  def current_group
    @group ||= current_user.groups.find(params[:group_id])
  end

  def current_ability
    Ability.new(current_user, current_group)
  end
end
