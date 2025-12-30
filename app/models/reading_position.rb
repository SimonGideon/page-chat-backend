class ReadingPosition < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # Validations
  validates :page_number, presence: true, numericality: { greater_than: 0 }
  validates :last_read_at, presence: true

  validates :user_id, uniqueness: {
    scope: :book_id,
    message: "already has a reading position for this book"
  }

  # Scopes
  scope :recent, -> { order(last_read_at: :desc) }

  # Helpers
  def update_position!(page:, scroll_offset: nil, percentage: nil)
    update!(
      page_number: page,
      scroll_offset: scroll_offset,
      percentage_completed: percentage,
      last_read_at: Time.current
    )
  end
end
