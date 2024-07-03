class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover_image

  validates :title, :description, :language, :published_at, presence: true
  validates :featured, inclusion: { in: [true, false] }
  # validate :only_pdf
  # validate :acceptable_images
  # before_save :extract_page_count
  # before_save :extract_cover_image, if: -> { pdf.attached? && !cover_image.attached? }
  private

  # PDF upload content-type validation
  def only_pdf
    # return unless pdf.attached?

    unless pdf.content_type == "application/pdf"
      errors.add(:pdf, "must be a PDF")
    end
  end

  # # Cover image upload validation
  # def acceptable_images
  #   return unless cover_image.attached?

  #   unless cover_image.byte_size <= 1.megabyte
  #     errors.add(:cover_image, "is too big")
  #   end

  #   acceptable_types = ["image/png", "image/jpg", "image/jpeg", "image/avif", "image/webp", "image/svg+xml"]
  #   unless acceptable_types.include?(cover_image.content_type)
  #     errors.add(:cover_image, "must be a JPEG, JPG, AVIF, WEBP, SVG, or PNG")
  #   end
  # end

  # Extract page count from attached PDF
  # def extract_page_count
  #   # return unless pdf.attached?

  #   reader = PDF::Reader.new(pdf.download)
  #   self.page_count = reader.page_count
  # end

  # Extract cover image from attached PDF and attach it
  # def extract_cover_image
  #   return unless pdf.attached?

  #   reader = PDF::Reader.new(pdf.download)
  #   # Extract the first image from the first page of the PDF
  #   page = reader.pages.first
  #   image = page&.images&.first

  #   return unless image

  #   # Attach the extracted image as the cover image
  #   cover_image.attach(io: StringIO.new(image.data), filename: "cover_image.jpg", content_type: "image/jpeg")
  # end

end
