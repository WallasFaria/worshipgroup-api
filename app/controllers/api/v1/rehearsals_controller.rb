class Api::V1::RehearsalsController < ApplicationController
  def create
    @rehearsal = current_presentation.rehearsals.new(rehearsal_params)

    if @rehearsal.save
      render :show, status: :created
    else
      render json: { errors: @rehearsal.errors }, status: :unprocessable_entity
    end
  end

  def update
    @rehearsal = current_presentation.rehearsals.find(params[:id])

    if @rehearsal.update(rehearsal_params)
      render :show, status: :ok
    else
      render json: { errors: @rehearsal.errors }, status: :unprocessable_entity
    end
  end

  private

  def rehearsal_params
    params.require(:rehearsal).permit(:date)
  end

  def current_group
    @current_group ||= current_api_v1_user.groups.find(params[:group_id])
  end

  def current_presentation
    @current_presentation ||= current_group.presentations.find(params[:presentation_id])
  end
end
