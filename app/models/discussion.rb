class Discussion < ApplicationRecord
  include ProfanityFilterable
  has_many :reports, as: :reportable, dependent: :destroy
  belongs_to :book
  belongs_to :user
  
  enum status: { active: 0, flagged: 1, hidden: 2 }

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :book_id, presence: true
  validates :user_id, presence: true
  belongs_to :deleted_by, class_name: "User", optional: true

  def soft_delete!(actor, reason: "deleted by author")
    update!(
      deleted: true,
      deleted_at: Time.current,
      deleted_by: actor,
      deletion_reason: reason,
      body: nil,
      title: "[Deleted Discussion]"
    )
  end

  def deleted_placeholder
    "This discussion was deleted"
  end

  def display_body
    deleted? ? deleted_placeholder : body
  end
end
