class UserSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :first_name, :last_name, :phone, :address, :country,
             :gender, :nationality, :city, :date_of_birth, :membership_number, :avatar_url

  attribute :avatar_url do |user|
    if user.avatar.attached?
      Rails.application.routes.url_helpers.url_for(user.avatar)
    end
  end

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime("%m/%d/%Y")
  end

  # format date of birth
  attribute :date_of_birth do |user|
    user.date_of_birth && user.date_of_birth.strftime("%m/%d/%Y")
  end
end
