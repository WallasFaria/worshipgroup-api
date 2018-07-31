class Api::V1::SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :destroy]

  def index
    page, per = 1, 10
    if params[:page].present?
      page = params[:page][:number] if params[:page][:number].present?
      per = params[:page][:size] if params[:page][:size].present?
    end

    @songs = Song.ransack(params[:q]).result.page(page).per(per)
  end

  def show
  end

  def create
    @song = current_group.songs.new(song_params)

    if @song.save
      render :show, status: :created, location: api_v1_songs_url(@song)
    else
      render json: { errors: @song.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @song.update(song_params)
      render :show, status: :ok, location: api_v1_songs_url(@song)
    else
      render json: { errors: @song.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy
  end

  private
    def set_song
      @song = current_group.songs.find(params[:id])
    end

    def current_group
      @group ||= current_api_v1_user.groups.find(params[:group_id])
    end

    def song_params
      params.require(:song).permit(:name, :artist, :url_youtube, :url_cipher)
    end
end
