class Api::V1::PresentationsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_presentation, only: [:show, :update, :destroy]

  def index
    @presentations = current_group.presentations.all
  end

  def show
  end

  def create
    @presentation = current_group.presentations.new(presentation_params)

    if @presentation.save
      render :show, status: :created,
        location: api_v1_group_presentation_url(current_group, @presentation)
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
    def current_group
      @group ||= current_api_v1_user.groups.find(params[:group_id])
    end

    def set_presentation
      @presentation = current_group.presentations.find(params[:id])
    end

    def presentation_params
      params.require(:presentation).permit(:date, :description, :group_id)
    end
end
