module ProfanityFilterable
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_profanity
  end

  private

  def sanitize_profanity
    return unless respond_to?(:body) && body.present?

    self.body = Obscenity.sanitize(body)
  end
end
