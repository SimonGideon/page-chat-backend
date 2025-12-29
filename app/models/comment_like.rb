# frozen_string_literal: true

class CommentLike < ApplicationRecord
  belongs_to :comment, counter_cache: :likes_count
  belongs_to :user

  validates :comment_id, uniqueness: { scope: :user_id }
end
