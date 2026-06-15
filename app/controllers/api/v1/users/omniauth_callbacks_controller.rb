module Api
  module V1
    module Users
      # OAuth callbacks are browser-based redirects, not API JSON calls.
      # We inherit directly from ActionController::Base (not our API ApplicationController)
      # so that the full Rack/Rails session and cookie stack is available,
      # which Devise and OmniAuth require to complete the handshake.
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        # In an API-only app, protect_from_forgery is not set up, so we
        # define it here on ActionController::Base's terms.
        include ActionController::RequestForgeryProtection
        protect_from_forgery with: :null_session

        def google_oauth2
          @user = User.from_omniauth(request.env["omniauth.auth"])

          if @user.persisted?
            sign_in(@user, store: false, bypass: false)
            token = request.env["warden-jwt_auth.token"] ||
                    Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first

            frontend_url = ENV.fetch("FRONTEND_URL", "https://pagechat.simongideon.me")
            redirect_to "#{frontend_url}/auth/google/callback?token=#{token}", allow_other_host: true
          else
            frontend_url = ENV.fetch("FRONTEND_URL", "https://pagechat.simongideon.me")
            redirect_to "#{frontend_url}/signin?error=google_auth_failed", allow_other_host: true
          end
        rescue => e
          Rails.logger.error("Google OAuth error: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
          frontend_url = ENV.fetch("FRONTEND_URL", "https://pagechat.simongideon.me")
          redirect_to "#{frontend_url}/signin?error=google_auth_failed", allow_other_host: true
        end

        def failure
          frontend_url = ENV.fetch("FRONTEND_URL", "https://pagechat.simongideon.me")
          redirect_to "#{frontend_url}/signin?error=google_auth_denied", allow_other_host: true
        end
      end
    end
  end
end
