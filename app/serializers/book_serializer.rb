class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :author, :description, :publication_year, :language,
             :publisher, :page_count, :isbn, :featured, :pdf_url, :cover_image_url

  def pdf_url
    Rails.application.routes.url_helpers.rails_blob_url(object.pdf, only_path: true) if object.pdf.attached?
  end

  def cover_image_url
    Rails.application.routes.url_helpers.rails_blob_url(object.cover_image, only_path: true) if object.cover_image.attached?
  end
end
