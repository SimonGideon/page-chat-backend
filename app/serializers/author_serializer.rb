class AuthorSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :biography, :website, :social_handle, :avatar_url

  attribute :avatar_url do |author|
    if author.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_path(author.avatar, only_path: true)
    end
  end
end
