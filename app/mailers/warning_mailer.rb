class WarningMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.warning_mailer.content_flagged.subject
  #
  def content_flagged
    @resource = params[:resource]
    @user = @resource.user
    
    # Construct the link to the flagged content
    frontend_url = ENV['FRONTEND_URL'] || 'http://localhost:5173'
    
    if @resource.is_a?(Discussion)
      book_id = @resource.book_id
      discussion_id = @resource.id
      @content_link = "#{frontend_url}/books/#{book_id}/read?discussionId=#{discussion_id}"
      @content_type = "Discussion"
    elsif @resource.is_a?(Comment)
      book_id = @resource.discussion.book_id
      discussion_id = @resource.discussion_id
      comment_id = @resource.id
      @content_link = "#{frontend_url}/books/#{book_id}/read?discussionId=#{discussion_id}&highlightCommentId=#{comment_id}"
      @content_type = "Comment"
    end

    mail(to: @user.email, subject: "Warning: Your content has been flagged")
  end
end
