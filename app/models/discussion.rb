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
end
