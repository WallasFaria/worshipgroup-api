class Api::V1::MusicsController < ApplicationController
  before_action :set_music, only: [:show, :update, :destroy]

  def index
    page, per = 1, 10
    if params[:page].present?
      page = params[:page][:number] if params[:page][:number].present?
      per = params[:page][:size] if params[:page][:size].present?
    end

    @musics = Music.ransack(params[:q]).result.page(page).per(per)
  end

  def show
  end

  def create
    @music = current_group.musics.new(music_params)

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
      @music = current_group.musics.find(params[:id])
    end

    def current_group
      @group ||= current_api_v1_user.groups.find(params[:group_id])
    end

    def music_params
      params.require(:music).permit(:name, :artist, :url_youtube, :url_cipher)
    end
end
