class StocksController < ApplicationController
    
    def search
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock].upcase)
            if @stock
                respond_to do |format|
                    format.js { render partial: 'users/result'  }
                end                 
            else
                @stock = nil
                respond_to do |format|
                  
                    format.js { render partial: 'users/result', flash: flash.now[:alert] = "Stock name #{params[:stock].upcase } not found"  }
                end 
                
            end
        else
            @stock = nil
            respond_to do |format|
             
                format.js { render partial: 'users/result', flash: flash.now[:alert] = "Please enter a symbol to search"  }
            end          
        end

    end
    
  end
  