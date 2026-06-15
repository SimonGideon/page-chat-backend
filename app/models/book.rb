class Book < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover_image
  belongs_to :author
  belongs_to :category
  belongs_to :language_ref, class_name: "Language", foreign_key: "language", optional: true
  has_many :favorites, dependent: :destroy
  has_many :discussions, dependent: :destroy

  has_many :reading_positions, dependent: :destroy
  has_many :readers, through: :reading_positions, source: :user


  validates :language, :published_at, presence: true
  # validates :pdf, :cover_image, attached: true, uniqueness: true

  validates :title, :description, presence: true
  validates :title, length: { minimum: 5 }
  validates :description, length: { minimum: 10 }
  validates :featured, inclusion: { in: [true, false] }
  validate :only_pdf
  validate :acceptable_images
  validate :unique_title_author_combination

  after_commit :extract_page_count, if: :pdf_newly_attached?

  scope :search_by_term, ->(term) {
    return all if term.blank?
    
    sanitized_term = "%#{sanitize_sql_like(term)}%"
    left_joins(:author, :category)
      .where("books.title ILIKE :term OR authors.name ILIKE :term OR categories.name ILIKE :term", term: sanitized_term)
  }

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

    unless cover_image.byte_size <= 5.megabytes
      errors.add(:cover_image, "must be under 5MB")
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
    update_column(:page_count, reader.page_count)
  rescue => e
    Rails.logger.error("extract_page_count failed for Book ##{id}: #{e.message}")
  end

  def pdf_newly_attached?
    attachment_changes["pdf"].present? || (pdf.attached? && page_count.nil?)
  end

  def unique_title_author_combination
    return unless author_id.present?

    if Book.where(author_id: author_id, title: title).where.not(id: id).exists?
      errors.add(:title, "Book Already Exists")
    end
  end
end
