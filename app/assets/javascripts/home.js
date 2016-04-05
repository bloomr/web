(function() {
  var sliceIt = function () {
    var $goDown = $('#transition');
    var $textWrapper = $('span', $goDown);
    var $goUp = $('.lift');
    $('#fullpage').fullpage({
        navigation: true,
        navigationPosition: 'right',
        anchors:['perdu', 'la_solution', 'kiffing_my_job', 'qui', 'footer'],
        onLeave: function(){
          $goDown.css({ opacity: 0 });
          },
        afterLoad: function(anchorLink, index){
          var transtion_text = '';
          switch(index) {
            case 1:
              transtion_text = 'la solution !';
              break;
            case 2:
              transtion_text = 'je kiffe, je peux aider ?';
              break;
            case 3:
              transtion_text = 'mais vous êtes qui ?';
              break;
            case 4:
              transtion_text = 'bas de page de malade';
              break;
          }
          $textWrapper.text(transtion_text);
          $goDown.css({ opacity: 1 });
          if(index == 5) {
            $goDown.hide();
          } else {
            $goDown.show();
          }
        }
      }
    );
    $goDown.click(function() { $.fn.fullpage.moveSectionDown(); });
    $goUp.click(function() { $.fn.fullpage.moveTo(1); });
    $('#lost-in-orientation').click(function() { $.fn.fullpage.moveSectionDown(); });
  };
  var destroyFullPage = function() {
    $.fn.fullpage.destroy('all');
    $(document).off('page:before-unload', destroyFullPage);
  };
  $(document).on('page:before-unload', destroyFullPage);
  sliceIt();
})();

