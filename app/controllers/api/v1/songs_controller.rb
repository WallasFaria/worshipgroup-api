class Api::V1::SongsController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :song, through: :group

  def index
    page, per = 1, 10
    if params[:page].present?
      page = params[:page][:number] if params[:page][:number].present?
      per = params[:page][:size] if params[:page][:size].present?
    end

    @songs = @songs.ransack(params[:q]).result.page(page).per(per)
  end

  def show
  end

  def create
    @song.group = @group

    if @song.save
      render :show, status: :created, location: api_v1_group_song_url(@group, @song)
    else
      render json: { errors: @song.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @song.update(song_params)
      render :show, status: :ok, location: api_v1_group_song_url(@group, @song)
    else
      render json: { errors: @song.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy
  end

  private
    def song_params
      params.require(:song).permit(:name, :artist, :url_youtube, :url_cipher)
    end
end
