class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(
      :email, :first_name, :last_name, :phone, :address, :country,
      :gender, :nationality, :city, :date_of_birth, :membership_number,
      :password, :avatar
    )
  end

  def account_update_params
    params.require(:user).permit(
      :email, :first_name, :last_name, :phone, :address, :country,
      :gender, :nationality, :city, :date_of_birth, :membership_number,
      :current_password, :avatar
    )
  end

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      begin
        resource.send_reset_password_instructions
      rescue StandardError => e
        Rails.logger.error("[SignUp] Failed to enqueue password setup email for user=#{resource.id}: #{e.class} - #{e.message}")
      end

      render json: {
        status: { code: 200, message: "Signed up successfully. Please check your email to activate your account and set a password." },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." },
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" },
      }, status: :unprocessable_entity
    end
  end
end
