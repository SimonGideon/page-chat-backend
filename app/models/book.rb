class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover_image
  validates :title, :description, :language, :page_count, :published_at, presence: true
  validates :featured, inclusion: { in: [true, false] }
  validates :pdf, attached: true, content_type: ["application/pdf"]
  validates :cover_image, attached: true, content_type: ["image/png", "image/jpg", "image/jpeg", "image/avif", "image/webp", "image/svg+xml"]
end
