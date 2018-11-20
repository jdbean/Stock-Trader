class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :get_stock_price

  def get_stock_quote(sym)
    api = config_adapter("https://api.iextrading.com/1.0/stock/")
    api.get "#{sym}/quote" 
  end

  protected
  # FIXME: add error handling
  def config_adapter(url)
    Faraday.new url do |conn|
      conn.use Faraday::Response::RaiseError
      conn.response :json, :content_type => /\bjson$/
      conn.adapter :typhoeus
    end
  end
end
