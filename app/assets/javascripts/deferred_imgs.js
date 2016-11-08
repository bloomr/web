(function() {
  var init = function() {
    // if its the first called by turbolinks, the dom is not ready
    // load images latter
    if (document.readyState !== 'complete') { return;  }
    var imgDefer = document.getElementsByTagName('img');
    for (var i=0; i<imgDefer.length; i++) {
      if(imgDefer[i].getAttribute('data-src')) {
        imgDefer[i].setAttribute('src',imgDefer[i].getAttribute('data-src'));
      } 
    } 
  };
  document.addEventListener('turbolinks:load', init);
  window.onload = init;
})()
