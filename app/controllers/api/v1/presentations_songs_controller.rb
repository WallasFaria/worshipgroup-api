class Api::V1::PresentationsSongsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    song = current_group.songs.find(params[:song_id])

    @presentations_song = current_presentation.songs.new(song_params.merge(song: song))

    if @presentations_song.save
      render :show, status: :created
    else
      render json: { errors: @presentations_song.errors }, status: :unprocessable_entity
    end
  end

  def update
    @presentations_song = current_presentation.songs.find params[:id]

    if @presentations_song.update(song_params)
      render :show, status: :ok
    else
      render json: { errors: @presentations_song.errors }, status: :unprocessable_entity
    end
  end

  private

  def song_params
    params.require(:presentations_song).permit(:tone)
  end

  def current_group
    @current_group ||= current_api_v1_user.groups.find(params[:group_id])
  end

  def current_presentation
    @current_presentation ||= current_group.presentations.find(params[:presentation_id])
  end
end
