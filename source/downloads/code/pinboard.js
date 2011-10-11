function pinboardNS_fetch_script(url) {
  (function(){
    var pinboardLinkroll = document.createElement('script');
    pinboardLinkroll.type = 'text/javascript';
    pinboardLinkroll.async = true;
    pinboardLinkroll.src = url;
    document.getElementsByTagName('head')[0].appendChild(pinboardLinkroll);
  })();
}
