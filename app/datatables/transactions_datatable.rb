class TransactionsDatatable < Effective::Datatable
  datatable do
    length 5  # 5, 10, 25, 50, 100, 500, :all
    order :updated_at, :desc
    # val :buy, label: "action" do |trans|
    #   "BUY"
    # end
    col :symbol, search: {as: :select, collection: current_user.transactions.map {|trans| trans.symbol}.uniq, multiple: true}
    val :total_cost, search: {fuzzy: true} do |transaction|
      transaction.quantity * transaction.share_price
    end.format do |total|
      number_to_currency(total)
    end
    col :quantity, label: "Shares"
    col :created_at, label: "Date" do |trans|
      trans.created_at.strftime("%D %R") 
    end
  end

  collection do
    Transaction.where(user_id: current_user.id)
  end

  # filters do
  #   filter :symbol, "", as: :select, collection: current_user.transactions.map {|trans| trans.symbol}.uniq
  # end
end
