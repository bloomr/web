init_hotjar = function(h,o,t,j,a,r){
    h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
    h._hjSettings={hjid:121346,hjsv:5};
    a=o.getElementsByTagName('body')[0];
    r=o.createElement('script');r.async=1;
    r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
    a.appendChild(r);
};


document.addEventListener('page:change', function() {
  init_hotjar(window,document,'//static.hotjar.com/c/hotjar-','.js?sv=');
});
