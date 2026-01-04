module ContentSafety
  class SuspicionGate
    def self.call(text:, user: nil, context: nil)
      new(text, user, context).suspicious?
    end
  
    def self.monitor(text:, user: nil, context: nil)
      service = new(text, user, context)
      
      if service.suspicious?
        user&.increment_violation_rating!
        
        # Content is suspicious, verify with Azure AI
        return AzureContentSafety.analyze(text)[:action]
      end
  
      :allow
    end
  
    def initialize(text, user, context)
      @text = text.to_s
      @user = user
      @context = context
    end
  
    def suspicious?
      profanity? ||
        aggressive_punctuation? ||
        caps_shouting? ||
        user_mention? ||
        elongated_words? ||
        risky_user?
    end
  
    private
  
    attr_reader :text, :user, :context
  
    # --- Rule checks ---
  
    def profanity?
      Obscenity.profane?(text)
    end
  
    def aggressive_punctuation?
      text.match?(/[\!\?]{3,}/)
    end
  
    def caps_shouting?
      text.scan(/[A-Z]/).count >= 5
    end
  
    def user_mention?
      text.match?(/@\w+/)
    end
  
    def elongated_words?
      text.match?(/(.)\1{3,}/)
    end
  
    def risky_user?
      return false unless user
  
      user.respond_to?(:recent_violations?) && user.recent_violations?
    end
  end
end
