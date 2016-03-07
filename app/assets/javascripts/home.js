(function() {
  var sliceIt = function () {
    var chevronDown = $('.glyphicon-chevron-down');
    var chevronUp = $('.glyphicon-chevron-up');
    $('#fullpage').fullpage({
        navigation: true,
        navigationPosition: 'right',
        afterLoad: function( anchorLink, index){
          console.log(index);
          if(index == 5) {
            chevronDown.hide();
          } else {
           chevronDown.show();
          }
        }
      }
    );
    chevronDown.click(function() { $.fn.fullpage.moveSectionDown(); });
    chevronUp.click(function() { $.fn.fullpage.moveTo(1); });
    $('#lost-in-orientation').click(function() { $.fn.fullpage.moveSectionDown(); });
  };
  $(document).on('page:change', sliceIt);
})();

