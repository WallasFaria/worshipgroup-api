class Api::V1::PresentationsSongsController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :presentation, through: :group
  load_and_authorize_resource :presentations_song, through: :presentation,
                              :through_association => :songs

  def create
    @presentations_song.presentation = @presentation

    if @presentations_song.save
      render :show, status: :created
    else
      render json: { errors: @presentations_song.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @presentations_song.update(song_params)
      render :show, status: :ok
    else
      render json: { errors: @presentations_song.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @presentation.songs.destroy @presentations_song
  end

  private

  def create_params
    params.require(:presentations_song).permit(:tone, :song_id)
  end

  def song_params
    params.require(:presentations_song).permit(:tone)
  end
end
