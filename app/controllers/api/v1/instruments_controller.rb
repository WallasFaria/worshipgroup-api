class Api::V1::InstrumentsController < ApplicationController
  def index
    render json: Instrument.all, status: :ok
  end
end
