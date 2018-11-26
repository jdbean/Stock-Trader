class TransactionsDatatable < Effective::Datatable
  datatable do
    length 5  # 5, 10, 25, 50, 100, 500, :all
    order :updated_at, :desc
    # val :buy, label: "action" do |trans|
    #   "BUY"
    # end

    col :symbol, search: { as: :select, collection: current_user.transactions.pluck(:symbol).uniq, include_null: false }
    col :quantity, label: "Shares", as: :integer

    val :total_cost,  as: :currency, search: { fuzzy: true } do |transaction|
      transaction.quantity * transaction.share_price
    end.format do |total|
      number_to_currency(total)
    end

    col :created_at, as: :datetime, label: "Date (UTC)"
  end

  filters do
    filter :symbol, nil, as: :select, collection: current_user.transactions.pluck(:symbol).uniq
    filter :start_date, Time.zone.now - 3.months, required: true
    filter :end_date, Time.zone.now.end_of_day
  end

  collection do
    scope = current_user.transactions.where('created_at > ?', filters[:start_date])

    if filters[:symbol].present?
      scope = scope.where(symbol: filters[:symbol])
    elsif filters[:end_date].present?
      scope = scope.where('created_at < ?', filters[:end_date])
    end

    scope
  end

  # filters do
  #   filter :symbol, "", as: :select, collection: current_user.transactions.map {|trans| trans.symbol}.uniq
  # end
end
