$(document).ready(() => {
  const sharePrice = $('#price-per-share');
  const priceTimeStmp = $('#price-timestamp');
  const qty = $('#share-qty');
  const total = $('#total-price');
  const sym = $('#symbol-input');
  const errors = $('.errors');

  // Remove any errors currently on page
  const clearErrors = () => errors.css('display', 'none');

  const fetchSharePrice = (symbol) => {
    fetch(`https://api.iextrading.com/1.0/stock/${symbol}/quote`)
      .then(resp => {
        if (!resp.ok) { throw resp };
        return resp.json();
      })
      .then(json => {
        const price = json.latestPrice;
        const timeStamp = json.latestUpdate;
        sharePrice.val(price);
        priceTimeStmp.val(makeDateString(timeStamp))
        total.val(`${(price * qty.val()).toFixed(2)}`);
      })
      .catch(err => {
        // FIXME: ADD ERROR RENDER
        err.text().then(errorMessage => {
          sharePrice.val(errorMessage)
          total.val();
        });
      });
  };

  const handleCheckPriceClick = () => {
    clearErrors();
    const symbol = sym.val();
    if (symbol === '') {
      sharePrice.val();
      total.val();
      priceTimeStmp.val('');
      return;
    } else {
      fetchSharePrice(symbol);
    };
  };

  const makeDateString = (timeStamp) => {
    let date = new Date(timeStamp);
    return date.toLocaleString();
  };

  $('#price-quote-btn').click(e => {
    e.preventDefault();
    handleCheckPriceClick();
  });

  $('#share-qty').bind('keyup mouseup', () => {
    clearErrors();
    const amt = qty.val();
    const cost = sharePrice.val();
    if (!amt || !cost) {
      total.val();
      return;
    }
    const orderTotal = (amt * cost).toFixed(2);
    total.val(`${orderTotal}`);
  });
});