# app/serializers/book_serializer.rb
class BookSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :language, :publisher, :page_count, :isbn, :featured, :recommended, :published_at, :pdf_url, :cover_image_url, :published_date, :author, :category

  attribute :pdf_url do |book|
    if book.pdf.attached?
      begin
        # Try to use url_for first (works if request context is available)
        Rails.application.routes.url_helpers.url_for(book.pdf)
      rescue
        # Fallback: build URL manually using default_url_options
        path = Rails.application.routes.url_helpers.rails_blob_path(book.pdf, only_path: true)
        default_options = Rails.application.routes.default_url_options || {}
        host = default_options[:host] || "localhost"
        port = default_options[:port]
        protocol = default_options[:protocol] || "http"
        port_str = port ? ":#{port}" : ""
        "#{protocol}://#{host}#{port_str}#{path}"
      end
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
end
