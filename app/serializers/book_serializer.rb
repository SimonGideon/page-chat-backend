# app/serializers/book_serializer.rb
class BookSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :language, :publisher, :page_count, :isbn, :featured, :published_at, :pdf_url, :cover_image_url, :published_date, :author, :category

  attribute :pdf_url do |book|
    if book.pdf.attached?
      Rails.application.routes.url_helpers.url_for(book.pdf)
    end
  end

  attribute :cover_image_url do |book|
    if book.cover_image.attached?
      Rails.application.routes.url_helpers.url_for(book.cover_image)
    end
  end

  attribute :published_date do |book|
    book.published_at&.strftime("%m/%d/%Y")
  end
end
