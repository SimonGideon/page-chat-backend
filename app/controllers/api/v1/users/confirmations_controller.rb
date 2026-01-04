require "cgi"

module Api
  module V1
    module Users
      class ConfirmationsController < Devise::ConfirmationsController
        include RackSessionFix
        respond_to :json

        def show
          confirmation_token = params[:confirmation_token].present? ? CGI.unescape(params[:confirmation_token]) : nil
          email = params[:email].present? ? CGI.unescape(params[:email]).downcase : nil
          
          token = confirmation_token || params[:confirmation_token] || params[:token]
          
          return render json: { error: "Token and email are required." }, status: :bad_request if token.blank? || email.blank?

          user = User.confirm_by_token(token)
          
          if user.present? && user.confirmed?
            if user.email.downcase != email
              return render json: { error: "Invalid confirmation link." }, status: :not_found
            end
            
            raw_token = user.send(:set_reset_password_token)
            user.save(validate: false)
            user.reload
            
            test_user = User.with_reset_password_token(raw_token)
            unless test_user&.id == user.id
              raw_token = user.send(:set_reset_password_token)
              user.save(validate: false)
              user.reload
            end
            
            render json: { 
              message: "Account confirmed successfully. Redirecting to set your password...",
              redirect_to: "#{ENV.fetch('FRONTEND_URL', 'http://localhost:5173')}/reset-password?token=#{ERB::Util.url_encode(raw_token)}&email=#{ERB::Util.url_encode(user.email)}"
            }, status: :ok
          else
            existing_user = User.find_by(email: email)
            if existing_user&.confirmed?
              raw_token = existing_user.send(:set_reset_password_token)
              existing_user.save(validate: false)
              existing_user.reload
              
              test_user = User.with_reset_password_token(raw_token)
              unless test_user&.id == existing_user.id
                raw_token = existing_user.send(:set_reset_password_token)
                existing_user.save(validate: false)
                existing_user.reload
              end
              
              return render json: { 
                message: "Account is already confirmed. Redirecting to set your password...",
                redirect_to: "#{ENV.fetch('FRONTEND_URL', 'http://localhost:5173')}/reset-password?token=#{ERB::Util.url_encode(raw_token)}&email=#{ERB::Util.url_encode(existing_user.email)}"
              }, status: :ok
            end
            
            render json: { 
              error: "Confirmation link is invalid or has expired.",
              errors: user&.errors&.full_messages || []
            }, status: :not_found
          end
        end
      end
    end
  end
end
