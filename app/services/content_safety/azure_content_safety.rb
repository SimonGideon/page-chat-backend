require 'net/http'
require 'uri'
require 'json'

module ContentSafety
  class AzureContentSafety
    def self.analyze(text)
      new(text).analyze
    end
  
    def initialize(text)
      @text = text
      @endpoint = ENV['AZURE_CONTENT_SAFETY_ENDPOINT']
      @api_key = ENV['AZURE_CONTENT_SAFETY_KEY']
    end
  
    def analyze
      return { action: :allow, analysis: [] } if @text.blank? || !configured?
  
      response = make_request
      
      if response.code == '200'
        result = JSON.parse(response.body)
        determine_action(result)
      else
        Rails.logger.error("Azure Content Safety Error: #{response.code} - #{response.body}")
        { action: :flag, analysis: [] } # Fail safe to flag
      end
    rescue StandardError => e
      Rails.logger.error("Azure Content Safety Exception: #{e.message}")
      { action: :flag, analysis: [] }
    end
  
    private
  
    def configured?
      @endpoint.present? && @api_key.present?
    end
  
    # Determine action based on severity analysis
    # Severity: 0-1 (Safe), 2-3 (Low/Medium Risk), 4+ (High Risk)
    def determine_action(result)
      categories = result['categoriesAnalysis'] || []
      max_severity = categories.map { |c| c['severity'] }.max || 0
  
      action = case max_severity
               when 0..1 then :allow
               when 2..3 then :flag
               else :hide
               end
      
      { action: action, analysis: categories }
    end
  
    def make_request
      uri = URI("#{@endpoint}/text:analyze?api-version=2023-10-01")
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Ocp-Apim-Subscription-Key'] = @api_key
      request.body = {
        text: @text,
        categories: ["Hate", "SelfHarm", "Sexual", "Violence"],
        blocklistNames: [],
        haltOnBlocklistHit: false,
        outputType: "FourSeverityLevels"
      }.to_json
  
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end
  end
end
