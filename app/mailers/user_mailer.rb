class UserMailer < ApplicationMailer
  def password_reset_notification(user, new_password)
    @user = user
    @new_password = new_password
    mail to: user.email, subject: "Your Page Chat access has been reset"
  end

  def account_activated(user)
    @user = user
    @login_url = "#{ENV.fetch('FRONTEND_URL', 'http://localhost:5173')}/signin"
    mail to: user.email, subject: "Welcome to Page Chat! Your account is active"
  end
end

