$(document).ready(() => {
  const alertContainer = $('.alert-container');
  setTimeout(() => {
    if (alertContainer[0].children) {
      alertContainer.empty()
    };
  }, 6000); 
});