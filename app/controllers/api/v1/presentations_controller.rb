class Api::V1::PresentationsController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :presentation, through: :group

  def index
  end

  def show
  end

  def create
    if @presentation.save
      render :show, status: :created,
        location: api_v1_group_presentation_url(@group, @presentation)
    else
      render json: { errors: @presentation.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @presentation.update(presentation_params)
      render :show, status: :ok,
        location: api_v1_group_presentation_url(current_group, @presentation)
    else
      render json: { errors: @presentation.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @presentation.destroy
  end

  private

    def presentation_params
      params.require(:presentation).permit(:date, :description, :group_id)
    end
end
