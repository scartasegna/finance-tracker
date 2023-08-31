"This is the finance tracker app from the Complete Ruby on Rails Developer course"

1 - add this two gems    gem 'alphavantage'  & gem 'httparty'

2 - get your FREE API key from here

3 - I did this step before the creation of the model so I'm not completely sure if it is needed, if you wanna continue to the next one and check is up to you but in config>initializers create a new file 'alphavantage.rb' and add this code

require 'alphavantage'
 
Alphavantage.configure do |config|
  config.api_key = 'YOUR API KEY'
end
4 - Follow the course until you crate Stock model and once it is created instead of the code showed use this one

require 'httparty'
 
class Stock < ApplicationRecord
    def self.new_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=YOUR API KEY")
        if response.code == 200 && response.parsed_response['Global Quote']
            response.parsed_response['Global Quote']['05. price']
        else
            nil
        end
    end
end
And you're good to go.

Once you finish with this you can call Stock.new_lookup('AAPL') in your rails console and you will get the price of apple but just continue with the course to know what I'm talking about, if I run into a problem, I'll let you know.

In section 262 your Stock model code will need to look like this

require 'httparty'
 
class Stock < ApplicationRecord
 
    def self.company_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_client[:api_key]}")
        if response.code == 200
          response.parsed_response['Name']
        else
          nil
        end
    end
 
    def self.new_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alpha_client[:api_key]}")
        if response.code == 200 && response.parsed_response['Global Quote']
          last_price = response.parsed_response['Global Quote']['05. price']
          name = company_lookup(ticker_symbol)
          new(ticker: ticker_symbol, name: name, last_price: last_price)
        else
          nil
        end
      end
end