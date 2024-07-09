class Discussion < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user, :book, :content, presence: true
end
