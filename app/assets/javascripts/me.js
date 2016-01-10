(function() {
  var make_it_editable = function () {
    $('.editable-group').each(function(i, el) {
      var editor = $('.editor', el)[0];
      var toolbar = $('.toolbar', el)[0];
      new wysihtml5.Editor(editor, {
        toolbar: toolbar,
        parserRules:  wysihtml5ParserRules
      });
    });

    $('form').on('submit', function() {
      $('.editor').each(function(i, div) {
        var $div = $(div);
        $('<input />').attr('type', 'hidden')
                  .attr('name', $div.attr('name'))
                  .attr('value', $div.html())
                  .appendTo('form');
        return true;
      });
    });
  };

  $(document).on('page:change', make_it_editable);
})();
