class ApplicationController < ActionController::API
  before_action :configure_sign_up_params, if: :devise_controller?
  rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired

  protected

  def handle_invalid_credentials
    render json: { status: { code: 401, message: "Invalid login email or password." } }, status: :unauthorized
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                                  :email, :password, :password_confirmation, :first_name,
                                                  :last_name, :phone, :address, :country,
                                                  :gender, :nationality, :city, :date_of_birth,
                                                  :membership_number,
                                                ])
  end
end
