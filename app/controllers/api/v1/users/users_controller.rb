module Api
  module V1
    module Users
      class UsersController < ApplicationController
        include JwtAuthenticatable
        
        respond_to :json
        before_action :authenticate_user!, only: [:update, :change_password]
        before_action :set_user, only: [:update]

        def index
          @users = User.all
          render json: {
                  status: { code: 200, message: "Successfully fetched users." },
                  data: UserSerializer.new(@users).serializable_hash[:data].map { |user| user[:attributes] },
                }, status: :ok
        end

        def update
          # Ensure user can only update their own profile
          unless @user.id == current_user.id
            return render json: {
              status: { code: 403, message: "You can only update your own profile." }
            }, status: :forbidden
          end

          if @user.update(user_params)
            render json: {
              status: { code: 200, message: "Profile updated successfully." },
              data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
            }, status: :ok
          else
            render json: {
              status: { code: 422, message: "Failed to update profile." },
              errors: @user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def change_password
          unless current_user.valid_password?(password_params[:current_password])
            return render json: {
              status: { code: 422, message: "Current password is incorrect." },
              errors: ["Current password is incorrect"]
            }, status: :unprocessable_entity
          end

          if current_user.update(
            password: password_params[:password],
            password_confirmation: password_params[:password_confirmation]
          )
            render json: {
              status: { code: 200, message: "Password changed successfully." }
            }, status: :ok
          else
            render json: {
              status: { code: 422, message: "Failed to change password." },
              errors: current_user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            status: { code: 404, message: "User not found." }
          }, status: :not_found
        end

        def user_params
          params.require(:user).permit(
            :first_name, :last_name, :phone, :address, :gender,
            :date_of_birth, :country_code, :city_id, :avatar, :email_notifications
          )
        end

        def password_params
          params.require(:user).permit(:current_password, :password, :password_confirmation)
        end
      end
    end
  end
end

