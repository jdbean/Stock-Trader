class TransactionsController < ApplicationController
  before_action :sanitize_page_params, only: [:create]
  before_action :validate_params, only: [:create]

  def index
    @datatable = TransactionsDatatable.new
  end

  def create
    if @errors.length > 0
      flash[:danger] = @errors
      redirect_to portfolio_path
      return
    end

    trans = current_user.transactions.create(
      symbol: params[:stock_symbol],
      quantity: params[:qty],
      share_price: params[:share_price]
    )

    if trans.save
      update_balance
    else
      flash[:danger] = "An unknown error occurred. "\
                       "No transaction has been made"
      redirect_to portfolio_path
      return
    end

    amt = params[:qty]
    @success = "Transaction successful. "\
               "You have bought #{amt} "\
               "share#{amt > 1 ? 's' : nil} "\
               "of #{params[:stock_symbol]} at "\
               "$#{@price} per share."

    flash[:success] = @success
    redirect_to portfolio_path
  end

  private

    def validate_params
      @errors = []

      unless validate_quantity
        @errors << "This application does not support "\
                   "the number of shares you have attempted "\
                   "to acquire."
      end

      @price = get_stock_quote(params[:stock_symbol])
      
      # Validate non-error state from API
      if @price.status != 200
        @errors << @price.body ? @price.body : "Server error."
      # If so, validate non-nil price value in response from API
      elsif @price.body["latestPrice"].nil?
        @errors << "An unkown error has occured."
      # If so, set @price to price from API 
      else
        @price = @price.body["latestPrice"]
      end

      @frontend_price = params[:share_price]

      unless validate_price
        @errors << "#{params[:stock_symbol]} is "\
                   "no longer available at #{@frontend_price}"
      end
 
      unless validate_balance
        @errors << "There are insufficient funds in your account "\
                   "to complete this transaction."
      end

      if @errors.length > 0
        @errors << "No transaction has occurred. "\
                   "Please try again."
      end

      @errors
    end

    # Check to make sure that the current balance is
    # sufficient to cover the requested transaction
    def validate_balance
      current_user.balance >= transaction_total
    end
    # A lower price than expected is always valid.
    # A price that is more than 1 percent greater
    # than expected is invalid.
    def validate_price
      @price / @frontend_price * 100.0 >= 99.0
    end
    # Valid quantity must be an integer greater than 0
    # and less than postgres max int size
    def validate_quantity
      qty = params[:qty]
      qty.between?(1, 2**31 - 1) && qty.is_a?(Integer)
    end

    def update_balance
      new_balance = current_user.balance - transaction_total
      current_user.update(balance: new_balance)
    end

    def transaction_params
      params.permit(:stock_symbol, :qty, :share_price)
    end

    def transaction_total
      params[:qty] * @price
    end

    def sanitize_page_params
      params[:stock_symbol] = params[:stock_symbol].upcase
      params[:qty] = params[:qty].to_i
      params[:share_price] = params[:share_price].to_f
    end
end
