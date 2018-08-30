class Api::V1::RehearsalsController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :presentation, through: :group
  load_and_authorize_resource :rehearsal, through: :presentation

  def create
    if @rehearsal.save
      render :show, status: :created
    else
      render json: { errors: @rehearsal.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @rehearsal.update(rehearsal_params)
      render :show, status: :ok
    else
      render json: { errors: @rehearsal.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @rehearsal.destroy
  end

  private

  def rehearsal_params
    params.require(:rehearsal).permit(:date)
  end
end
