(function() {
  var isMobile = ($(window).width() <= 480);

  var makeNavReadable = function (ev){
    var headerHeight = 80;
    var trigger = $('.intro').outerHeight() - headerHeight;
    if (window.pageYOffset> trigger) {
      $('nav').css('background-color','#ee933f');
    } else {
      $('nav').css('background-color','transparent');
    }
  };

  var toogleMobileMenu = function() { $('nav > ul').toggle(); };
  var hideSubmenus = function() { $('.submenu').hide(); };

  var exitTimer;

  var pageChange = function() {
    if ($('.new_header').length === 0) { return; }

    var $navHeaders = $('header nav > ul > li > a');

    var showOnlySubmenu = function($submenu) {
      var localSubmenus = $('.submenu').slice();
      localSubmenus.splice(localSubmenus.index($submenu), 1);
      $submenu.show();
      $(localSubmenus).hide();
    };

    var toggleOnlySubmenu = function($submenu) {
      var localSubmenus = $('.submenu').slice();
      localSubmenus.splice(localSubmenus.index($submenu), 1);
      $submenu.toggle();
      $(localSubmenus).hide();
    };

    var menuClick = function(e) {
      e.stopPropagation();
      var $target = $('.submenu', e.target.parentNode);
      toggleOnlySubmenu($target);
    };

    var menuHover = function(e) {
      clearTimeout(exitTimer);
      var $target = $('.submenu', e.target.parentNode);
      showOnlySubmenu($target);
    };

    var hideAfter = function () {
      clearTimeout(exitTimer);
      exitTimer = setTimeout(hideSubmenus, 3000);
    };

    var clearExitTimer = function () {
      clearTimeout(exitTimer);
    };

    if(isMobile) {
      $('.top .menu').click(toogleMobileMenu);
    } else {
      $navHeaders.hover(menuHover, hideAfter);
      $('.submenu').hover(clearExitTimer, hideAfter);
      window.addEventListener('scroll', makeNavReadable, false);
    }
    $navHeaders.click(menuClick);
    $('body').click(hideSubmenus);
  };

  var beforeUnload = function() {
    if ($('.new_header').length === 0) { return; }
    $('body').off('click', hideSubmenus);
    $('header nav > ul > li > a').off();
    window.removeEventListener('scroll', makeNavReadable, false);
    $('.top .menu').off();
    $('.submenu').off();
  };

  $(document).on('page:change', pageChange);
  $(document).on('page:before-unload', beforeUnload);

})();
