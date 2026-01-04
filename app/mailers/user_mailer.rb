class UserMailer < ApplicationMailer
  default from: 'notifications@pagechat.com'

  def account_activated(user)
    @user = user
    mail(to: @user.email, subject: 'Account Activated')
  end

  def violation_notice(user, content_status, violation_rating)
    @user = user
    @content_status = content_status
    @violation_rating = violation_rating
    @action_description = case content_status.to_sym
                          when :hidden
                            "hidden from public view because it violated our safety policies (High Risk)."
                          when :flagged
                            "flagged for review because it contained potentially sensitive content."
                          else
                            "flagged."
                          end

    mail(to: @user.email, subject: 'Content Violation Notice')
  end
end
