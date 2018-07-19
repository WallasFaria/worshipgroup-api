class Api::V1::MusicsController < ApplicationController
  before_action :set_music, only: [:show, :update, :destroy]

  def index
    @musics = Music.all
  end

  def show
  end

  def create
    @music = Music.new(music_params)

    if @music.save
      render :show, status: :created, location: api_v1_musics_url(@music)
    else
      render json: { errors: @music.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @music.update(music_params)
      render :show, status: :ok, location: api_v1_musics_url(@music)
    else
      render json: { errors: @music.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @music.destroy
  end

  private
    def set_music
      @music = Music.find(params[:id])
    end

    def music_params
      params.require(:music).permit(:name, :artist, :url_youtube, :url_cipher)
    end
end
