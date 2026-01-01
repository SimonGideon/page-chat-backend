Obscenity.configure do |config|
  # Replace profane words with ***
  config.replacement = :stars

  # Default blacklist + your custom words
  config.blacklist = Obscenity::Base.blacklist + %w[
    fuck shit asshole bitch bastard cunt
  ]

  # Words that look bad but are OK in context
  config.whitelist = %w[
    hell damn
  ]
end
