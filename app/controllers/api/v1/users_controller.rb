class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    if search_params.present?
      @users = User.ransack(search_params).result.page(1).per(5)
    else
      @users = []
    end
  end

  def add_roles
    @user = current_api_v1_user
    params[:role_ids].each do |id|
      @user.roles << Role.find(id)
    end

    if @user.save
      render :show, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def remove_role
    role = current_api_v1_user.roles.find(params[:id])
    current_api_v1_user.roles.destroy(role)
  end

  private
    def search_params
      {
        email_eq: params[:q],
        name_cont_any: params[:q],
        telephone_eq: params[:q],
        m: 'or'
      } if params[:q].present?
    end
end
