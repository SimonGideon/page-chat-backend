class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def sign_up_params
    permitted = params.require(:user).permit(
      :email, :first_name, :last_name, :phone, :address,
      :gender, :date_of_birth,
      :password, :avatar,
      :country_code, :city_id,
      :country_id, # Accept country_id for backward compatibility, will convert to code
      :country, :city # Keep for backward compatibility during transition
    )
    
    # Convert country_id to country_code if provided
    if permitted[:country_id].present? && permitted[:country_code].blank?
      country = Country.find_by(id: permitted[:country_id])
      permitted[:country_code] = country&.code
      permitted.delete(:country_id)
    end
    
    # Convert country name to code if provided
    if permitted[:country].present? && permitted[:country_code].blank?
      country = Country.find_by("LOWER(name) = ?", permitted[:country].downcase)
      permitted[:country_code] = country&.code
      permitted.delete(:country)
    end
    
    # Convert city name to ID if provided
    if permitted[:city].present? && permitted[:city_id].blank? && permitted[:country_code].present?
      city = City.where("LOWER(cities.name) = ? AND cities.country_code = ?", 
                        permitted[:city].downcase, permitted[:country_code])
                 .first
      permitted[:city_id] = city&.id
      permitted.delete(:city)
    end
    
    permitted.except(:country, :country_id)
  end

  def account_update_params
    permitted = params.require(:user).permit(
      :email, :first_name, :last_name, :phone, :address,
      :gender, :date_of_birth,
      :current_password, :avatar,
      :country_code, :city_id,
      :country_id, # Accept country_id for backward compatibility, will convert to code
      :country, :city # Keep for backward compatibility during transition
    )
    
    # Convert country_id to country_code if provided
    if permitted[:country_id].present? && permitted[:country_code].blank?
      country = Country.find_by(id: permitted[:country_id])
      permitted[:country_code] = country&.code
      permitted.delete(:country_id)
    end
    
    # Convert country name to code if provided
    if permitted[:country].present? && permitted[:country_code].blank?
      country = Country.find_by("LOWER(name) = ?", permitted[:country].downcase)
      permitted[:country_code] = country&.code
      permitted.delete(:country)
    end
    
    # Convert city name to ID if provided
    if permitted[:city].present? && permitted[:city_id].blank? && permitted[:country_code].present?
      city = City.where("LOWER(cities.name) = ? AND cities.country_code = ?", 
                        permitted[:city].downcase, permitted[:country_code])
                 .first
      permitted[:city_id] = city&.id
      permitted.delete(:city)
    end
    
    permitted.except(:country, :country_id)
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
