class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reportable, polymorphic: true

  validates :reporter_id, uniqueness: { scope: [:reportable_type, :reportable_id], message: "has already reported this content" }
  validate :cannot_report_own_content

  after_create :check_thresholds

  private

  def cannot_report_own_content
    if reportable.respond_to?(:user_id) && reportable.user_id == reporter_id
      errors.add(:base, "You cannot report your own content")
    end
  end

  def check_thresholds
    count = reportable.reports.reload.count
    if count >= 5
      reportable.hidden! unless reportable.hidden?
    elsif count >= 3
      unless reportable.flagged?
        reportable.flagged!
        WarningMailer.with(resource: reportable).content_flagged.deliver_later
      end
    end
  end
end
