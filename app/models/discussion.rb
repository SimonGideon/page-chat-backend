class Discussion < ApplicationRecord
  belongs_to :book
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :book_id, presence: true
  validates :user_id, presence: true
end
