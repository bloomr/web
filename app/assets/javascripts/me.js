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


  var activeToogle = function () {
    var $controlPanelTrigger = $('.control-panel-trigger');
    var $questionsTrigger = $('.questions-trigger');
    var $controlPanel = $('.control-panel');
    var $questions = $('.questions');

    var showControlPanelHideQuestions = function () {
      $controlPanel.show();
      $controlPanelTrigger.addClass('on');
      $questions.hide();
      $questionsTrigger.removeClass('on');
    };

    var showQuestionsHideControlPanel = function () {
      $controlPanel.hide();
      $controlPanelTrigger.removeClass('on');
      $questions.show();
      $questionsTrigger.addClass('on');
    };

    $controlPanelTrigger.click(showControlPanelHideQuestions);
    $questionsTrigger.click(showQuestionsHideControlPanel);
  };

  var disableToogle = function () {
    var $controlPanel = $('.control-panel');
    var $questions = $('.questions');

    $controlPanelTrigger.unbind();
    $questionsTrigger.unbind();
  };

  $(document).on('page:change', make_it_editable);
  $(document).on('page:change', activeToogle);
  $(document).on('page:change', function() { $(".select2").select2(); });
  $(document).on('page:before-unload', disableToogle);
})();
