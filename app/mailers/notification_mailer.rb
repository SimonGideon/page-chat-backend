class NotificationMailer < ApplicationMailer
  def new_notification
    @notification = params[:notification]
    @recipient = @notification.recipient
    @actor = @notification.actor
    @action = @notification.action
    
    subject = case @action
              when 'liked_comment'
                "#{@actor.first_name} liked your comment"
              when 'replied_to_comment'
                "#{@actor.first_name} replied to your comment"
              when 'commented_on_discussion'
                "#{@actor.first_name} commented on your discussion"
              when 'mentioned_in_comment'
                "#{@actor.first_name} mentioned you in a comment"
              when 'mentioned_in_discussion'
                "#{@actor.first_name} mentioned you in a discussion"
              else
                "New Notification"
              end

    mail(to: @recipient.email, subject: "Page Chat: #{subject}")
  end
end
