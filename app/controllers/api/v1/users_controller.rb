class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def add_instruments
    @user = current_api_v1_user
    params[:instrument_ids].each do |id|
      @user.instruments << Instrument.find(id)
    end

    if @user.save
      render :me, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
end
