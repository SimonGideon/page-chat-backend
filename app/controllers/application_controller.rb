class ApplicationController < ActionController::API
  include JwtAuthenticatable
  before_action :configure_sign_up_params, if: :devise_controller?
  rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired
  rescue_from JWT::DecodeError, with: :handle_jwt_invalid

  protected

  def handle_jwt_expired
    render json: { 
      status: { code: 401, message: "Your session has expired. Please log in again." }
    }, status: :unauthorized
  end

  def handle_jwt_invalid
    render json: { 
      status: { code: 401, message: "Invalid authentication token." }
    }, status: :unauthorized
  end

  def handle_invalid_credentials
    render json: { 
      status: { code: 401, message: "Invalid login email or password." }
    }, status: :unauthorized
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation, :first_name,
      :last_name, :phone, :address, :country,
      :gender, :city, :date_of_birth,
    ])
  end
end
