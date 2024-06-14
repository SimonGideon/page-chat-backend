class ApplicationController < ActionController::API
  before_action :configure_sign_up_params, if: :devise_controller?

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                                  :email, :password, :password_confirmation, :first_name,
                                                  :last_name, :phone, :home_church, :residence, :city,
                                                  :date_of_birth, :membership_number,
                                                ])
  end
end
