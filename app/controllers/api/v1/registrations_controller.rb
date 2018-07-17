class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private

  def attributes_permited
    [
      :name,
      :email,
      :date_of_birth,
      :telephone,
      :password,
      :password_confirmation
    ]
  end

  def sign_up_params
    params.permit attributes_permited
  end

  def account_update_params
    params.permit attributes_permited
  end
end
