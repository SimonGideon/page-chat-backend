module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        def create
          requested_email = password_params[:email]&.downcase
          return render json: { error: "Email is required." }, status: :bad_request if requested_email.blank?

          user = User.find_by(email: requested_email)

          if user.present?
            begin
              user.send_reset_password_instructions
            rescue StandardError => e
              Rails.logger.error("[PasswordReset] Failed to send reset instructions: #{e.class} - #{e.message}")
              return render json: { error: "Unable to send reset email at the moment." }, status: :internal_server_error
            end
          end

          render json: { message: "If that email exists in our records, you will receive a reset link shortly." }, status: :ok
        end

        def show
          require "cgi"
          
          token = params[:token].present? ? CGI.unescape(params[:token]) : nil
          return render json: { error: "Token is required." }, status: :bad_request if token.blank?

          user = User.with_reset_password_token(token)
          
          if user.present? && user.reset_password_period_valid?
            render json: { email: user.email }, status: :ok
          else
            render json: { error: "Reset link is invalid or has expired." }, status: :not_found
          end
        end

        def update
          require "cgi"
          
          token = params[:token].present? ? CGI.unescape(params[:token]) : nil
          return render json: { error: "Token is required." }, status: :bad_request if token.blank?

          user = User.with_reset_password_token(token)
          
          unless user.present?
            return render json: { error: "Reset link is invalid or has expired." }, status: :not_found
          end

          user = User.reset_password_by_token(
            reset_password_token: token,
            password: params[:password],
            password_confirmation: params[:password_confirmation],
          )

          if user.errors.empty?
            render json: { message: "Password has been updated successfully." }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def password_params
          permitted = params.permit(:email, :format, password: [:email])
          permitted[:email] ||= permitted.dig(:password, :email)
          permitted.slice(:email)
        end
      end
    end
  end
end
