class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :user, :book, presence: true
  validates :book_id, uniqueness: { scope: :user_id, message: "is already favorited" }
end
