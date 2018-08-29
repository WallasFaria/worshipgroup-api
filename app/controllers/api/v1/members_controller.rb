class Api::V1::MembersController < Api::V1::GroupAbilitiesController
  load_and_authorize_resource :group, through: :current_user
  load_and_authorize_resource :member, through: :group

  def create
    @member.group = @group

    if @member.save
      render :show, status: :created
    else
      render json: { errors: @member.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @member.update(permission: member_params[:permission])
      render :show, status: :ok
    else
      render json: { errors: @member.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @member.destroy
  end

  private

  def member_params
    params.require(:member).permit(:user_id, :permission)
  end
end
