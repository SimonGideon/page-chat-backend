module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include RackSessionFix
        respond_to :json

        def create
          params_hash = sign_up_params.to_h
          city_id = params_hash.delete(:city_id)
          country_code = params_hash.delete(:country_code)
          # Also remove city and country to prevent association assignment
          params_hash.delete(:city)
          params_hash.delete(:country)
          params_hash.delete(:country_id)
          # Remove password if present - password will be set via email verification
          params_hash.delete(:password)
          params_hash.delete(:password_confirmation)

          build_resource(params_hash)

          # Set city_id and country_code directly using write_attribute to avoid association assignment issues
          resource.write_attribute(:city_id, city_id) if city_id.present?
          resource.write_attribute(:country_code, country_code) if country_code.present?

          resource.save
          yield resource if block_given?
          if resource.persisted?
            if resource.active_for_authentication?
              set_flash_message! :notice, :signed_up
              sign_up(resource_name, resource)
              respond_with resource, location: after_sign_up_path_for(resource)
            else
              set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
              expire_data_after_sign_in!
              respond_with resource, location: after_inactive_sign_up_path_for(resource)
            end
          else
            clean_up_passwords resource
            set_minimum_password_length
            respond_with resource
          end
        end

        private

        def sign_up_params
          permitted = params.require(:user).permit(
            :email, :first_name, :last_name, :phone, :address,
            :gender, :date_of_birth,
            :avatar, # Password is not required - will be set via email verification
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
            message = "Signed up successfully. Please check your email to confirm your account and set your password."

            render json: {
              status: { code: 200, message: message },
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
    end
  end
end

