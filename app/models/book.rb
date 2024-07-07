class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover_image
  belongs_to :author
  belongs_to :category
  has_many :favorites, dependent: :destroy

  validates :title, :description, :language, :published_at, presence: true
  validates :featured, inclusion: { in: [true, false] }
  validate :only_pdf
  validate :acceptable_images

  after_commit :extract_page_count, if: :pdf_attached?

  private

  # PDF upload content-type validation
  def only_pdf
    return unless pdf.attached?

    unless pdf.content_type == "application/pdf"
      errors.add(:pdf, "Book must be a PDF")
    end
  end

  # Cover image upload validation
  def acceptable_images
    return unless cover_image.attached?

    unless cover_image.byte_size <= 1.megabyte
      errors.add(:cover_image, "is too big")
    end

    acceptable_types = ["image/png", "image/jpg", "image/jpeg", "image/avif", "image/webp", "image/svg+xml"]
    unless acceptable_types.include?(cover_image.content_type)
      errors.add(:cover_image, "must be a JPEG, JPG, AVIF, WEBP, SVG, or PNG")
    end
  end

  # Extract page count from attached PDF
  def extract_page_count
    return unless pdf.attached?

    reader = PDF::Reader.new(StringIO.new(pdf.download))
    self.update_column(:page_count, reader.page_count)
  end

  # Check if the PDF is attached
  def pdf_attached?
    pdf.attached?
  end
end
