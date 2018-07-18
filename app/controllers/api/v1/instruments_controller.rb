class Api::V1::InstrumentsController < ApplicationController
  def index
    @instruments = Instrument.all
    render :index , status: :ok
  end
end
