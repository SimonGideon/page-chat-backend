# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  def create
    email = params.dig(:user, :email) || params.dig(:session, :user, :email)
    password = params.dig(:user, :password) || params.dig(:session, :user, :password)
    
    user = User.find_by(email: email&.downcase)
    
    if user.nil?
      return render json: {
        status: { code: 401, message: "Invalid login email or password." }
      }, status: :unauthorized
    end
    
    unless user.valid_password?(password)
      return render json: {
        status: { code: 401, message: "Invalid login email or password." }
      }, status: :unauthorized
    end
    
    unless user.confirmed?
      return render json: {
        status: { code: 401, message: "Please confirm your account by clicking the link in your email before logging in." }
      }, status: :unauthorized
    end
    
    unless user.active_for_authentication?
      return render json: {
        status: { code: 401, message: user.inactive_message || "Your account is not active." }
      }, status: :unauthorized
    end
    
    # Sign in the user
    sign_in(:user, user)
    
    # Generate JWT token manually
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    
    # Set the Authorization header
    response.headers['Authorization'] = "Bearer #{token}"
    
    render json: {
      status: { code: 200, message: "Logged in successfully." },
      data: UserSerializer.new(user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: { code: 200, message: "Logged out successfully." },
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Couldn't find an active session." },
      }, status: :unauthorized
    end
  end
end
