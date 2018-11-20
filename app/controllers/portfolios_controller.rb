class PortfoliosController < ApplicationController

  def index
    puts get_stock_price("aapl")

  end

end
