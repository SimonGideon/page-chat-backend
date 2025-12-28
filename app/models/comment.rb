class Comment < ApplicationRecord
  belongs_to :discussion, counter_cache: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :user, presence: true
  validates :body, presence: true
end
