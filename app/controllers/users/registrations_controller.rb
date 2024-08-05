class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone, :home_church, :residence, :city, :date_of_birth, :membership_number, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone, :home_church, :residence, :city, :date_of_birth, :membership_number, :current_password, :avatar)
  end

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: { code: 200, message: "Signed up successfully." },
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
