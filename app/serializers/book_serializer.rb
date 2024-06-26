class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :language, :publisher, :page_count, :isbn, :featured, :pdf_url, :cover_image_url

  attribute :pdf_url do |book|
    if book.pdf.attached?
      Rails.application.routes.url_helpers.rails_blob_url(book.pdf, only_path: true)
    end
  end

  attribute :cover_image_url do |book|
    if book.cover_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(book.cover_image, only_path: true)
    end
  end
end
