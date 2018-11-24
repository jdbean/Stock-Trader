class PortfoliosDatatable < Effective::Datatable
  datatable do
    length 5  # 5, 10, 25, 50, 100, 500, :all

    col :symbol,
        search: { as: :select, collection: current_user.transactions.pluck(:symbol).uniq },
        responsive: "1" do |sym|
      case attributes[:status_hash][sym]
      when -1
        content_tag(:span, sym, class: "red")
      when 1
        content_tag(:span, sym, class: "green")
      else
        content_tag(:span, sym, class: "gray")
      end
    end
    col :shares, as: :integer, responsive: "4"
    col :openening_price, as: :currency, responsive: "5"
    col :latest_price, as: :currency, responsive: "5"
    col :daily_performance, as: :percent, responsive: "3" do |perf|
      percent = number_to_percentage(perf)
      case
      when perf < 0.0
        content_tag(:span, percent, class: "red")
      when perf > 0.0
        content_tag(:span, percent, class: "green")
      when perf == 0.0
        content_tag(:span, percent, class: "gray")
      end
    end
    val :current_value,  as: :currency, sort: true, responsive: "2", search: { fuzzy: true } do |holding|
      sym = holding[0]
      value = (holding[1] * holding[3])
      @total_value += value
      value = number_to_currency(value)
      case attributes[:status_hash][sym]
      when -1
        content_tag(:span, value, class: "red")
      when 1
        content_tag(:span, value, class: "green")
      else
        content_tag(:span, value, class: "gray")
      end
    end
    aggregate :total, label: "Total Portfolio Value" do |values, column|
      if column[:name] == :symbol
        "Portfolio Value"
      elsif column[:name] == :current_value 
        content_tag(:span, number_to_currency(@total_value))
      end
    end
  end

  # charts do
  #   chart :holdings, 'BarChart' do |collection|
  #     collection.map do |s|
  #       [s[0],s[4]]
  #     end
  #   end
  # end

  collection do
    @total_value = 0
    attributes[:portfolio]
  end
end
