class Api::V1::RolesController < ApplicationController
  def index
    @roles = Role.all
    render :index , status: :ok
  end
end
