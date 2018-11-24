class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :get_stock_price

  def get_stock_quote(sym)
    api = config_adapter("https://api.iextrading.com/1.0/stock/")
    api.get "#{sym}/quote" 
  end

  def get_batch_quote(sym_arr)
    sym_arrs = sym_arr.each_slice(100).to_a
    api = config_adapter("https://api.iextrading.com/1.0/stock/market/batch")
    result = {}

    sym_arrs.each do |symbols|
      resp = api.get '', { :symbols => sym_arr.join(','), :types => 'quote' }
      return resp if resp.status != 200
      result = result.merge(resp.body)
    end

    return result
  end

  protected

  def config_adapter(url)
    Faraday.new url do |conn|
      # conn.use Faraday::Response::RaiseError
      conn.response :json, :content_type => /\bjson$/
      conn.adapter :typhoeus
    end
  end
end
