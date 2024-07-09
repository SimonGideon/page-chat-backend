class BookSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :language, :publisher, :page_count, :isbn, :featured, :published_at, :pdf_url, :cover_image_url, :published_date, :author, :category

  attribute :pdf_url do |book|
    if book.pdf.attached?
      Rails.application.routes.url_helpers.rails_blob_path(book.pdf, only_path: true)
    end
  end

  attribute :cover_image_url do |book|
    if book.cover_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(book.cover_image, only_path: true)
    end
  end

  attribute :published_date do |book|
    book.published_at&.strftime("%m/%d/%Y")
  end
end
