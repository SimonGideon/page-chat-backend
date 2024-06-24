class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover_image

  validates :title, :description, :language, :page_count, :published_at, presence: true
  validates :featured, inclusion: { in: [true, false] }
  validates :pdf, attached: true, content_type: ["application/pdf"]
  validates :cover_image, attached: true, content_type: ["image/png", "image/jpg", "image/jpeg", "image/avif", "image/webp", "image/svg+xml"]

  before_save :extract_page_count, if: :pdf_attached?
  before_save :extract_cover_image, if: -> { pdf.attached? && !cover_image.attached? }

  private

  def extract_page_count
    return unless pdf.attached?

    reader = PDF::Reader.new(pdf.download)
    self.page_count = reader.page_count
  end

  def pdf_attached?
    pdf.attached?
  end

  def extract_cover_image
    return unless pdf.attached?

    reader = PDF::Reader.new(pdf.download)
    # Extract the first image from the first page of the PDF
    page = reader.pages.first
    image = page.images.first

    return unless image

    # Attach the extracted image as the cover image
    cover_image.attach(io: StringIO.new(image.data), filename: "cover_image.jpg", content_type: "image/jpeg")
  end
end
