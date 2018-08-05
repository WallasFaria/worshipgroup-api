class Api::V1::RolesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    @roles = Role.all
    render :index , status: :ok
  end
end
