$(document).ready(() => {
  const sharePrice = $('#price-per-share');
  const priceTimeStmp = $('#price-timestamp');
  const qty = $('#share-qty');
  const total = $('#total-price');
  const sym = $('#symbol-input');
  const alertContainer = $('.alert-container');

  const renderAlert = (message) => {
    alertContainer.append(`<div class="alert alert-warning">${message}</div>`)
    setTimeout(() => clearAlerts(), 6000); 
  }
  // Remove any alerts currently on page
  const clearAlerts = () => {
    const alert = $('.alert');
    alert.remove();
  }
  const fetchSharePrice = (symbol) => {
    fetch(`https://api.iextrading.com/1.0/stock/${symbol}/quote`)
      .then(resp => {
        if (!resp.ok) { throw resp };
        return resp.json();
      })
      .then(json => {
        const price = json.latestPrice;
        const timeStamp = json.latestUpdate;
        validQuote = true
        sharePrice.val(price.toFixed());
        priceTimeStmp.val(makeDateString(timeStamp))
        total.val(`${(price * qty.val()).toFixed(2)}`);
      })
      .catch(err => {
        err.text().then(errorMessage => {
          renderAlert(`Server Error: ${errorMessage}`)
          validQuote = false
          sharePrice.val(null);
          total.val(null);
          priceTimeStmp.val(null);
          total.val();
        });
      });
  };

  const handleCheckPriceClick = () => {
    clearAlerts();
    const symbol = sym.val();
    if (symbol === '') {
      sharePrice.val(null);
      total.val(null);
      priceTimeStmp.val(null);
      return;
    } else {
      fetchSharePrice(symbol);
    };
  };

  const makeDateString = (timeStamp) => {
    let date = new Date(timeStamp);
    return date.toLocaleString();
  };

  $('#price-quote-btn').unbind('click').click(e => {
    e.preventDefault();
    handleCheckPriceClick();
  });

  $('#share-qty').bind('keyup mouseup', () => {
    clearAlerts();
    const amt = qty.val();
    const cost = sharePrice.val();
    if (!amt || !cost) {
      total.val();
      return;
    }
    const orderTotal = (amt * cost).toFixed(2);
    total.val(`${orderTotal}`);
  });

  $('#purchase-submit-button').unbind('click').bind("click",function(e){
    if (sym.val() && !sharePrice.val()) {
      renderAlert(`Your purchase cannot be completed. Pricing data for ${sym.val()} is not available. ${sym.val()} may not be a valid stock symbol.`)
      e.preventDefault();
      return
    };
 });
});