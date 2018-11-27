class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :get_stock_price

  def get_stock_quote(sym)
    url = "https://api.iextrading.com/1.0/stock/"
    api = config_adapter(url)
    api.get "#{sym}/quote"
  end

  def get_batch_quote(sym_arr)
    url = "https://api.iextrading.com/1.0/stock/market/batch"
    sym_arrs = sym_arr.each_slice(100).to_a
    api = config_adapter(url)
    result = {}

    sym_arrs.each do |symbols|
      resp = api.get "", { symbols: sym_arr.join(','),
                           types: "quote" }
      return nil if resp.status != 200
      result.merge!(resp.body)
    end

    result
  end

  protected

  def config_adapter(url)
    Faraday.new url do |conn|
      # conn.use Faraday::Response::RaiseError
      conn.response :json, content_type: /\bjson$/
      conn.adapter :typhoeus
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end