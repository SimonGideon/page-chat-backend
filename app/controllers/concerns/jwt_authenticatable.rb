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
      render json: { status: { code: 401, message: "Invalid token." } }, status: :unauthorized
    end
  end

  def authenticate_user_optional
    token = request.headers['Authorization']&.split(' ')&.last
    return if token.blank?

    begin
      decoded = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, algorithm: 'HS256')
      user_id = decoded.first['sub']
      user = User.find_by(id: user_id)
      
      if user && user.jti == decoded.first['jti']
        @current_user = user
      end
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      # Ignore errors for optional auth
    end
  end
end

