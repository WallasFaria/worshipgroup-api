class Api::V1::PresentationsMembersController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :presentation, through: :group
  load_and_authorize_resource :presentations_member,
                              :through => :presentation,
                              :through_association => :members

  def create
    @presentations_member.presentation = @presentation

    if @presentations_member.save
      if params[:role_ids].present?
        @presentations_member.roles << params[:role_ids].map {|id| Role.find id }
      end

      render :show, status: :created
    else
      render json: { errors: @presentations_member.errors },
             status: :unprocessable_entity
    end
  end

  def update
    if params[:role_ids].present?
      @presentations_member.roles.destroy_all
      @presentations_member.roles << params[:role_ids].map {|id| Role.find id }
    end

    render :show, status: :ok
  end

  def destroy
    @presentation.members.destroy @presentations_member
  end

  private
  def presentations_member_params
    params.require('presentations_member').permit(:member_id)
  end
end
