class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :user, :book, :content, presence: true
  validates :body, presence: true
end
