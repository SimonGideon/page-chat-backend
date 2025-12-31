class UserSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :first_name, :last_name, :phone, :address,
             :gender, :date_of_birth, :avatar_url, :email_notifications

  attribute :country do |user|
    user.country&.name || user.read_attribute(:country)
  end

  attribute :country_code do |user|
    user.country&.code
  end

  attribute :city do |user|
    user.city&.name || user.read_attribute(:city)
  end

  attribute :city_id do |user|
    user.city_id
  end

  attribute :avatar_url do |user|
    user.avatar_url
  end

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime("%m/%d/%Y")
  end

  # format date of birth
  attribute :date_of_birth do |user|
    user.date_of_birth && user.date_of_birth.strftime("%m/%d/%Y")
  end
end
