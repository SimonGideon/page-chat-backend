module ProfanityFilterable
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_profanity
  end

  # Configure Obscenity to replace vowels with asterisks and use custom blacklist
  Obscenity.configure do |config|
    config.blacklist = Rails.root.join("config", "blacklist.yml")
    config.replacement = ->(word){ word.gsub(/[aeiou]/i, '*') }
  end

  private

  def sanitize_profanity
    return unless respond_to?(:body) && body.present?

    if Obscenity.profane?(body)
      self.status = :flagged if respond_to?(:status=)
      
      # Manual smart masking: replace vowels in offensive words
      offensive_words = Obscenity.offensive(body)
      offensive_words.each do |word|
        mask = word.gsub(/[aeiou]/i, '*')
        # Use case-insensitive replacement for the word in the body
        self.body = body.gsub(/#{Regexp.escape(word)}/i, mask)
      end
    end
  end
end
