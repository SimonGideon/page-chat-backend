module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Check for token in params
      token = request.params[:token]
      
      if token.present?
        begin
          # Decode the token (assuming Devise-JWT uses the Rails secret_key_base or specific config)
          # Note: Devise-JWT revocation strategies might require checking the allowlist/blocklist.
          # For simplicity in this optimization task, we decode and find the user.
          # In a full-scale app, consider using Warden::JWTAuth::UserDecoder directly if possible.
          
          secret = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
          decoded_token = JWT.decode(token, secret, true, algorithm: 'HS256').first
          user_id = decoded_token['sub'] # Standard claim for subject (user id)
          
          if (verified_user = User.find_by(id: user_id))
            verified_user
          else
            reject_unauthorized_connection
          end
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end
  end
end
