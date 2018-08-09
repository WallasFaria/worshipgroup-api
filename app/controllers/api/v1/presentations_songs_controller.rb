class Api::V1::PresentationsSongsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    song = current_group.songs.find(params[:song_id])

    @presentations_song = current_presentation.songs.new(song: song, tone: params[:tone])

    if @presentations_song.save
      render :show, status: :created
    else
      render json: { errors: @presentations_song.errors }, status: :unprocessable_entity
    end
  end

  private

  def current_group
    @current_group ||= current_api_v1_user.groups.find(params[:group_id])
  end

  def current_presentation
    @current_presentation ||= current_group.presentations.find(params[:presentation_id])
  end
end
