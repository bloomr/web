(function() {

  var move = function(e) {
    var link = $(e.target).data('link');

    $('html, body').animate({
      scrollTop: ($("#" + link).offset().top - $('nav').height())
    }, 750);

    return false;
  };

  $(document).on('click', '[data-link]', move);
})();
