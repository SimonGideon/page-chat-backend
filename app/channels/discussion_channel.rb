class DiscussionChannel < ApplicationCable::Channel
  def subscribed
    discussion = Discussion.find_by(id: params[:discussion_id])
    if discussion
      stream_from "discussion_#{discussion.id}"
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
