$(document).ready(() => {
  const sharePrice = $('#price-per-share');
  const priceTimeStmp = $('#price-timestamp');
  const qty = $('#share-qty');
  const total = $('#total-price');
  const errors = $('.errors');

  // Remove any errors currently on page
  const clearErrors = () => errors.css('display', 'none');

  const fetchSharePrice = (sym) => {
    fetch(`https://api.iextrading.com/1.0/stock/${sym}/quote`)
      .then(resp => {
        if (!resp.ok) { throw resp };
        return resp.json();
      })
      .then(json => {
        console.log(json)
        const price = json.latestPrice;
        const timeStamp = json.latestUpdate;
        sharePrice.val(price);
        priceTimeStmp.val(makeDateString(timeStamp))
        total.val(`${(price * qty.val()).toFixed(2)}`);
      })
      .catch(err => {
        // FIXME: ADD ERROR RENDER
        console.log(err)
        err.text().then(errorMessage => {
          sharePrice.val(errorMessage)
          total.val();
        });
      });
  };

  const handleCheckPriceClick = () => {
    clearErrors();
    const sym = $('#symbol-input').val();
    if (sym === '') {
      sharePrice.val();
      total.val();
      priceTimeStmp.val('');
      return;
    } else {
      fetchSharePrice(sym);
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