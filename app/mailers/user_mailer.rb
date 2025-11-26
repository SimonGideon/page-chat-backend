class UserMailer < ApplicationMailer
  def password_reset_notification(user, new_password)
    @user = user
    @new_password = new_password
    mail to: user.email, subject: "Your Page Chat access has been reset"
  end
end

