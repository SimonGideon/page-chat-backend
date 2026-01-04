class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true
  validates :biography, presence: true

  # Social handles helpers - returns array of {platform, url} hashes
  def social_handles
    return [] if social_handle.blank?
    begin
      parsed = JSON.parse(social_handle)
      if parsed.is_a?(Array)
        parsed.map(&:symbolize_keys)
      elsif parsed.is_a?(Hash)
        # Legacy single handle format
        [parsed.symbolize_keys]
      else
        []
      end
    rescue JSON::ParserError
      # Fallback for old format or plain string
      if social_handle.include?(':')
        parts = social_handle.split(':', 2)
        [{ platform: parts[0], url: parts[1] }]
      else
        [{ platform: nil, url: social_handle }]
      end
    end
  end

  def social_handles=(handles)
    if handles.is_a?(Array) && handles.any?
      # Filter out empty entries
      valid_handles = handles.select { |h| h[:platform].present? && h[:url].present? }
      self.social_handle = valid_handles.map { |h| { platform: h[:platform], url: h[:url] } }.to_json
    else
      self.social_handle = nil
    end
  end
end
