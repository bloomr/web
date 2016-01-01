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
  };
  $(document).on('page:change', make_it_editable);
})();
