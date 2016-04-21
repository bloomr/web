(function() {
  var showWhatsNew = function(){ $('.my-work').hide(); $('.whats-new').show(); $('.whatsNewTrigger').addClass('active'); $('.myWorkTrigger').removeClass('active');  };
  var showMyWork = function(){ $('.my-work').show(); $('.whats-new').hide(); $('.whatsNewTrigger').removeClass('active'); $('.myWorkTrigger').addClass('active'); };
  var showTribeChoice = function(){ console.log('loulou');$('.panel-default').hide(); $('.panel-tribe-choice').show(); };

  var make_it_editable = function () {
    $('.editable-group').each(function(i, el) {
      var editor = $('.editor', el)[0];
      var toolbar = $('.toolbar', el)[0];
      new wysihtml5.Editor(editor, {
        toolbar: toolbar,
        parserRules:  wysihtml5ParserRules
      });
    });

    $('#questions_form').on('submit', function() {
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
  var bind = function(){
    if( $('#me').length === 0 ) { return; }
    $('.whatsNewTrigger').click(showWhatsNew);
    $('.myWorkTrigger').click(showMyWork);
    $('.tribeChoiceTrigger').click(showTribeChoice);
    make_it_editable();
    $(".select2").select2();
  };
  var unbind = function(){
    if( $('#me').length === 0 ) { return; }
    $('.whatsNewTrigger').off();
    $('.myWorkTrigger').off();
    $('.tribeChoiceTrigger').off();
  };
  $(document).on('page:change', bind);
  $(document).on('page:before-unload', unbind);
})();
