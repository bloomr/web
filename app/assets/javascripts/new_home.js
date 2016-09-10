(function() {
  var pageChange = function() {
    if ($('#new_home').length === 0) { return; }

    var $submenus = $('.submenu');
    var $navHeaders = $('header nav > ul > li > a');
    var $newHome = $('#new_home');

    var hideSubemus = function() { $submenus.hide(); };
    $newHome.click(hideSubemus);

    var showOnlySubmenu = function($submenu) {
      var localSubmenus = $submenus.slice();
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
  };

  var beforeUnload = function() {
    if ($('#new_home').length === 0) { return; }
    $('#new_home').off();
    $('header nav > ul > li > a').off();
  };

  $(document).on('page:before-unload', beforeUnload);
  $(document).on('page:change', pageChange);
})();
