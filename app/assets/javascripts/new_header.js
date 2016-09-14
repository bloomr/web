(function() {
  var makeNavReadable = function (ev){
    if (window.pageYOffset>430) {
      $('nav').css('background-color','#ee933f');
    } else {
      $('nav').css('background-color','transparent');
    }
  };

  var hideSubmenus = function() { $('.submenu').hide(); };

  var pageChange = function() {
    if ($('.new_header').length === 0) { return; }

    var $navHeaders = $('header nav > ul > li > a');

    var showOnlySubmenu = function($submenu) {
      var localSubmenus = $('.submenu').slice();
      localSubmenus.splice(localSubmenus.index($submenu), 1);
      $submenu.show();
      $(localSubmenus).hide();
    };

    var menuClick = function(e) {
      e.stopPropagation();
      var $target = $('.submenu', e.target.parentNode);
      showOnlySubmenu($target);
    };
    $navHeaders.click(menuClick);

    var menuHover = function(e) {
      var $target = $('.submenu', e.target.parentNode);
      showOnlySubmenu($target);
    };
    $navHeaders.hover(menuHover);

    window.addEventListener('scroll', makeNavReadable, false);
    $('body').click(hideSubmenus);
  };

  var beforeUnload = function() {
    if ($('.new_header').length === 0) { return; }
    $('body').off('click', hideSubmenus);
    $('header nav > ul > li > a').off();
    window.removeEventListener('scroll', makeNavReadable, false);
  };

  $(document).on('page:change', pageChange);
  $(document).on('page:before-unload', beforeUnload);
})();
