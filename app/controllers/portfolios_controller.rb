class PortfoliosController < ApplicationController
  def index
    @portfolio = get_prices(sum_holdings)
    @datatable = PortfoliosDatatable.new(portfolio: @portfolio, status_hash: @status_hash)
  end

  private

  def sum_holdings
    current_user.transactions.group(:symbol).sum(:quantity)
  end

  def get_prices(holdings_hash)
    # Check to make sure user has holdings
    return if holdings_hash.empty?
    symbols = holdings_hash.keys
    data = get_batch_quote(symbols)
    @status_hash = {}

    symbols.collect do |sym|
      info = data[sym]["quote"]
      @status_hash[sym] = status(info["open"], info["latestPrice"])
      [sym,
       holdings_hash[sym],
       info["open"],
       info["latestPrice"],
       percent_difference(info["open"],info["latestPrice"])
      ]
    end
  end

  def status(opn, curr)
    case
    when opn > curr
      -1
    when opn < curr
      1
    else
      0
    end
  end

  def percent_difference(first, second)
    diff = (second - first) / first
    diff * 100
  end
end
