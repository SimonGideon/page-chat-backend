module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        def create
          requested_email = password_params[:email]&.downcase
          if requested_email.blank?
            Rails.logger.warn("[PasswordReset] Request received without an email payload.")
            return render json: { error: "Email is required." }, status: :bad_request
          end

          user = User.find_by(email: requested_email)

          if user.present?
            Rails.logger.info("[PasswordReset] Attempting to send reset instructions for user=#{user.id} email=#{user.email}.")
            begin
              user.send_reset_password_instructions
              Rails.logger.info("[PasswordReset] Reset instructions successfully enqueued for email=#{user.email}.")
            rescue StandardError => e
              Rails.logger.error(
                "[PasswordReset] Failed to send reset instructions for email=#{user.email}: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
              )
              return render json: { error: "Unable to send reset email at the moment." }, status: :internal_server_error
            end
          else
            Rails.logger.info("[PasswordReset] Reset requested for non-existent email=#{requested_email}.")
          end

          render json: { message: "If that email exists in our records, you will receive a reset link shortly." }, status: :ok
        end

        def show
          token = params[:token]
          return render json: { error: "Token is required." }, status: :bad_request if token.blank?

          user = User.with_reset_password_token(token)
          if user.present? && user.reset_password_period_valid?
            render json: { email: user.email }, status: :ok
          else
            render json: { error: "Reset link is invalid or has expired." }, status: :not_found
          end
        end

        def update
          token = params[:token]
          return render json: { error: "Token is required." }, status: :bad_request if token.blank?

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

