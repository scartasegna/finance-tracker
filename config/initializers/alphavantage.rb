require 'alphavantage'
 
Alphavantage.configure do |config|
  config.api_key = Rails.application.credentials.alphavantage[:sandbox_api_key]
end