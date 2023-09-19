class Stock < ApplicationRecord
    require 'httparty'

    has_many :user_stocks
    has_many :users, through: :user_stocks

    validates :name, :ticker, presence: true
 
    def self.new_lookup(ticker_symbol)
        ticker_response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:sandbox_api_key]}")
        puts "#{ticker_response}"

        company_response = HTTParty.get("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:sandbox_api_key]}")
        puts "#{company_response}"

        if ticker_response.code == 200 && ticker_response.parsed_response['Global Quote'] && company_response.code == 200 && company_response.parsed_response['bestMatches']

            price = ticker_response.parsed_response['Global Quote']['05. price']
            companies_info = company_response.parsed_response['bestMatches']
            companies_names = companies_info.map { |c| c['2. name'] if c['1. symbol'] == ticker_symbol}
            company_name = companies_names[0]

            if company_name != "" && !company_name.nil?
                new(ticker: ticker_symbol, name: company_name, last_price: price)
            else
                nil
            end
        else
            nil
        end
    end
end

