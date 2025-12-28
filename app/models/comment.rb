class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :user, :book, :content, presence: true
  validates :body, presence: true
  belongs_to :discussion, counter_cache: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id


end
