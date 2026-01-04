# Preview all emails at http://localhost:3000/rails/mailers/warning_mailer_mailer
class WarningMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/warning_mailer_mailer/content_flagged
  def content_flagged
    WarningMailer.content_flagged
  end

end
