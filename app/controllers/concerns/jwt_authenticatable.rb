module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    
    if token.blank?
      render json: { status: { code: 401, message: "Authentication required." } }, status: :unauthorized
      return
    end

    begin
      decoded = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, algorithm: 'HS256')
      user_id = decoded.first['sub']
      @current_user = User.find(user_id)
      
      if @current_user.jti != decoded.first['jti']
        render json: { status: { code: 401, message: "Token has been revoked." } }, status: :unauthorized
        return
      end
    rescue JWT::ExpiredSignature
      render json: { status: { code: 401, message: "Token has expired." } }, status: :unauthorized
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { status: { code: 401, message: "Invalid token." } }, status: :unauthorized
    end
  end
end

