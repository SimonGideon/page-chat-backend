# app/serializers/book_serializer.rb
class BookSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :language, :publisher, :page_count, :isbn, :featured, :recommended, :published_at, :pdf_url, :cover_image_url, :published_date, :category

  attribute :author do |book|
    {
      id: book.author.id,
      name: book.author.name,
      biography: book.author.biography,
      email: book.author.email,
      avatar_url: book.author.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_path(book.author.avatar, only_path: true) : nil,
      social_handles: book.author.social_handles
    }
  end

  attribute :pdf_url do |book, params|
    if params[:current_user] && book.pdf.attached?
      # Authenticated user: Return full PDF
      begin
        Rails.application.routes.url_helpers.url_for(book.pdf)
      rescue
        path = Rails.application.routes.url_helpers.rails_blob_path(book.pdf, only_path: true)
        default_options = Rails.application.routes.default_url_options || {}
        host = default_options[:host] || "localhost"
        port = default_options[:port]
        protocol = default_options[:protocol] || "http"
        port_str = port ? ":#{port}" : ""
        "#{protocol}://#{host}#{port_str}#{path}"
      end
    else
      # Guest user: Return preview URL
      Rails.application.routes.url_helpers.preview_api_v1_book_url(book.id, host: (Rails.application.routes.default_url_options[:host] || "localhost:3000"))
    end
  end

  attribute :cover_image_url do |book|
    if book.cover_image.attached?
      begin
        # Try to use url_for first (works if request context is available)
        Rails.application.routes.url_helpers.url_for(book.cover_image)
      rescue
        # Fallback: build URL manually using default_url_options
        path = Rails.application.routes.url_helpers.rails_blob_path(book.cover_image, only_path: true)
        default_options = Rails.application.routes.default_url_options || {}
        host = default_options[:host] || "localhost"
        port = default_options[:port]
        protocol = default_options[:protocol] || "http"
        port_str = port ? ":#{port}" : ""
        "#{protocol}://#{host}#{port_str}#{path}"
      end
    end
  end

  attribute :published_date do |book|
    book.published_at&.strftime("%m/%d/%Y")
  end

  attribute :is_favorited do |book, params|
    if params[:current_user]
      params[:current_user].favorites.exists?(book_id: book.id)
    else
      false
    end
  end

  attribute :favorite_id do |book, params|
    if params[:current_user]
      params[:current_user].favorites.find_by(book_id: book.id)&.id
    end
  end

  attribute :reading_position do |book, params|
    if params[:current_user]
      position = params[:current_user].reading_positions.find_by(book: book)
      if position
        {
          page_number: position.page_number,
          scroll_offset: position.scroll_offset,
          percentage_completed: position.percentage_completed,
          last_read_at: position.last_read_at
        }
      end
    end
  end
end
