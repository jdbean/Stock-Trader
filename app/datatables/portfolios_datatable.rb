class PortfoliosDatatable < Effective::Datatable
  datatable do
    order :current_value, :desc
    length 5  # 5, 10, 25, 50, 100, 500, :all

    val :symbol, as: :string, search: { fuzzy: true }, responsive: "1" do |holding|
      holding[0]
    end.format do |sym|
      # search: { as: :select, collection: current_user.transactions.select(:symbol).distinct.pluck(:symbol), include_null: false  },
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

    val :daily_performance, responsive: "3" do |holding|
      holding[4]
    end.format do |perf|
      percent = number_to_percentage(perf, precison: 2)
      case
      when perf < 0.0
        content_tag(:span, percent, class: "red")
      when perf > 0.0
        content_tag(:span, percent, class: "green")
      when perf == 0.0
        content_tag(:span, percent, class: "gray")
      end
    end

    val :current_value, responsive: "2", search: { fuzzy: true } do |holding|
      sym = holding[0]
      value = (holding[1] * holding[3])
      @total_value += value
      value
    end.format do |val, holding|
      sym = holding[0].match(/>(.*)</)[1]
      value = number_to_currency(val)
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
