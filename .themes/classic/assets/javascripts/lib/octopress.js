var octopress = (function(){
  return {
    addMobileNav: function () {
      var mainNav = $('ul.main-navigation, ul[role=main-navigation]').before('<fieldset class="mobile-nav">')
      var mobileNav = $('fieldset.mobile-nav').append('<select>');
      mobileNav.find('select').append('<option value="">Navigate&hellip;</option>');
      var addOption = function(i, option) {
        mobileNav.find('select').append('<option value="' + this.href + '">&raquo; ' + $(this).text() + '</option>');
      }
      mainNav.find('a').each(addOption);
      $('ul.subscription a').each(addOption);
      mobileNav.find('select').bind('change', function(event) {
        if (event.target.value) { window.location.href = event.target.value; }
      });
    }

    , addSidebarToggler: function () {
      if(!$('body').hasClass('sidebar-footer')) {
        $('#content').append('<span class="toggle-sidebar"></span>');
        $('.toggle-sidebar').bind('click', function(e) {
          e.preventDefault();
          if ($('body').hasClass('collapse-sidebar')) {
            $('body').removeClass('collapse-sidebar');
          } else {
            $('body').addClass('collapse-sidebar');
          }
        });
      }
      var sections = $('.sidebar section');
      if (sections.length > 1) {
        sections.each(function(index){
          if ((sections.length >= 3) && index % 3 === 0) {
            $(this).addClass("first");
          }
          var count = ((index +1) % 2) ? "odd" : "even";
          $(this).addClass(count);
        });
      }
      if (sections.length >= 3){ $('aside.sidebar').addClass('thirds'); }
    }
    
    , testFeature: function (features) {
      getTestClasses = function (tests) {
        classes = '';
        if (typeof(tests.join) == 'function') {
          for (var i=0; i < features.length; i++)
            classes += getClass(features[i]) + ' ';
        } else {
          classes = getClass(tests);
        }
        return classes;
      }

      getClass = function (test) {
        return ((Modernizr.testAllProps(test) ? test : "no-"+test).toLowerCase())
      }

      $('html').addClass(getTestClasses(features));
    }

    , flashVideoFallback: function (){
      var flashplayerlocation = "/assets/jwplayer/player.swf",
          flashplayerskin = "/assets/jwplayer/glow/glow.xml";
      $('video').each(function(i, video){
        video = $(video);
        if (!Modernizr.video.h264 && swfobject.getFlashPlayerVersion() || window.location.hash.indexOf("flash-test") !== -1){
          video.children('source[src$=mp4]').first().map(i, function(source){
            var src = $(source).attr('src'),
                id = 'video_'+Math.round(1 + Math.random()*(100000)),
                width = video.attr('width'),
                height = parseInt(video.attr('height'), 10) + 30;
                video.after('<div class="flash-video"><div><div id='+id+'>');
            swfobject.embedSWF(flashplayerlocation, id, width, height + 30, "9.0.0",
              { file : src, image : video.attr('poster'), skin : flashplayerskin } ,
              { movie : src, wmode : "opaque", allowfullscreen : "true" }
            );
          });
          video.remove();
        }
      });
    }

    , wrapFlashVideos: function () {
      $('object').each(function(i, object) {
        if( $(object).find('param[name=movie]').length ){
          $(object).wrap('<div class="flash-video">')
        }
      });
      $('iframe[src*=vimeo],iframe[src*=youtube]').wrap('<div class="flash-video">')
    }
  }
})();

$(document).ready(function() {
  octopress.wrapFlashVideos();
  octopress.testFeature(['maskImage', 'transform']);
  octopress.flashVideoFallback();
  octopress.addMobileNav();
  octopress.addSidebarToggler();
});

