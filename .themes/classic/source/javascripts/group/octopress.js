var octopress = (function(){
  return {
    addMobileNav: function () {
      var mainNav = $('ul.main-navigation, ul[role=main-navigation]').before('<fieldset class="mobile-nav">')
      var mobileNav = $('fieldset.mobile-nav').append('<select>');
      mobileNav.find('select').append('<option value="">Navigate&hellip;</option>');
      var addOption = function() {
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
    
    , addCodeLineNumbers: function () {
      if (navigator.appName === 'Microsoft Internet Explorer') { return; }
      $('div.gist-highlight').each(function(index) {
        var tableStart = '<table><tbody><tr><td class="gutter">',
            lineNumbers = '<pre class="line-numbers">',
            tableMiddle = '</pre></td><td class="code">',
            tableEnd = '</td></tr></tbody></table>',
            count = $('.line', this).length;
        for (var i=1;i<=count; i++) {
          lineNumbers += '<span class="line-number">'+i+'</span>\n';
        }
        var table = tableStart + lineNumbers + tableMiddle + '<pre>'+$('pre', this).html()+'</pre>' + tableEnd;
        $(this).html(table);
      });
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
      $('video').each(function(video){
        video = $(video);
        if (!Modernizr.video.h264 && swfobject.getFlashPlayerVersion() || window.location.hash.indexOf("flash-test") !== -1){
          video.children('source[src$=mp4]').first().map(function(source){
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
      $('object').each(function(object) {
        object = $(object);
        if ( $('param[name=movie]', object).length ) {
          var wrapper = object.before('<div class="flash-video"><div>').previous();
          $(wrapper).children().append(object);
        }
      });
      $('iframe[src*=vimeo],iframe[src*=youtube]').each(function(iframe) {
        iframe = $(iframe);
        var wrapper = iframe.before('<div class="flash-video"><div>').previous();
        $(wrapper).children().append(iframe);
      });
    }

    /* Sky Slavin, Ludopoli. MIT license.  * based on JavaScript Pretty Date * Copyright (c) 2008 John Resig (jquery.com) * Licensed under the MIT license.  */
    /* Updated considerably by Brandon Mathis */
 
    , prettyDate: function (time) {
      if (navigator.appName === 'Microsoft Internet Explorer') {
        return "<span>&infin;</span>"; // because IE date parsing isn't fun.
      }
      var say = {
        just_now:    " now",
        minute_ago:  "1m",
        minutes_ago: "m",
        hour_ago:    "1h",
        hours_ago:   "h",
        yesterday:   "1d",
        days_ago:    "d",
        last_week:   "1w",
        weeks_ago:   "w"
      };

      var current_date = new Date(),
          current_date_time = current_date.getTime(),
          current_date_full = current_date_time + (1 * 60000),
          date = new Date(time),
          diff = ((current_date_full - date.getTime()) / 1000),
          day_diff = Math.floor(diff / 86400);

      if (isNaN(day_diff) || day_diff < 0) { return "<span>&infin;</span>"; }

      return day_diff === 0 && (
        diff < 60 && say.just_now ||
        diff < 120 && say.minute_ago ||
        diff < 3600 && Math.floor(diff / 60) + say.minutes_ago ||
        diff < 7200 && say.hour_ago ||
        diff < 86400 && Math.floor(diff / 3600) + say.hours_ago) ||
        day_diff === 1 && say.yesterday ||
        day_diff < 7 && day_diff + say.days_ago ||
        day_diff === 7 && say.last_week ||
        day_diff > 7 && Math.ceil(day_diff / 7) + say.weeks_ago;
    }

    , renderDeliciousLinks: function (items) {
      var output = "<ul>";
      for (var i=0,l=items.length; i<l; i++) {
        output += '<li><a href="' + items[i].u + '" title="Tags: ' + (items[i].t == "" ? "" : items[i].t.join(', ')) + '">' + items[i].d + '</a></li>';
      }
      output += "</ul>";
      $('#delicious').html(output);
    }

    // Twitter fetcher for Octopress (c) Brandon Mathis // MIT License
    , twitter: (function(){

      function linkifyTweet(text, url) {
        // Linkify urls, usernames, hashtags
        text = text.replace(/(https?:\/\/)([\w\-:;?&=+.%#\/]+)/gi, '<a href="$1$2">$2</a>')
          .replace(/(^|\W)@(\w+)/g, '$1<a href="http://twitter.com/$2">@$2</a>')
          .replace(/(^|\W)#(\w+)/g, '$1<a href="http://search.twitter.com/search?q=%23$2">#$2</a>');

        // Use twitter's api to replace t.co shortened urls with expanded ones.
        for (var u in url) {
          if(url[u].expanded_url != null){
            var shortUrl = new RegExp(url[u].url, 'g');
            text = text.replace(shortUrl, url[u].expanded_url);
            var shortUrl = new RegExp(">"+(url[u].url.replace(/https?:\/\//, '')), 'g');
            text = text.replace(shortUrl, ">"+url[u].display_url);
          }
        }
        return text
      }

      function render(tweets, twitter_user) {
        var timeline = document.getElementById('tweets'),
            content = '';

        for (var t in tweets) {
          content += '<li>'+'<p>'+'<a href="http://twitter.com/'+twitter_user+'/status/'+tweets[t].id_str+'">'+octopress.prettyDate(tweets[t].created_at)+'</a>'+linkifyTweet(tweets[t].text.replace(/\n/g, '<br>'), tweets[t].entities.urls)+'</p>'+'</li>';
        }
        timeline.innerHTML = content;
      }

      return {
        getFeed: function(target){
          target = $(target);
          if (target.length == 0) return;
          var user = target.attr('data-user');
          var count = parseInt(target.attr('data-count'), 10);
          var replies = target.attr('data-replies') == 'true';
          $.ajax({
              url: "http://api.twitter.com/1/statuses/user_timeline/" + user + ".json?trim_user=true&count=" + (count + 20) + "&include_entities=1&exclude_replies=" + (replies ? "0" : "1") + "&callback=?"
            , dataType: 'jsonp'
            , error: function (err) { $('#tweets li.loading').addClass('error').text("Twitter's busted"); }
            , success: function(data) { render(data.slice(0, count), user); }
          });
        }
      }
    })()
    
    , github: (function(){

      htmlEscape = function (str) {
        return String(str)
          .replace(/&/g, '&amp;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;');
      }

      function render(target, data){
        var i = 0, repos = '';

        for(i = 0; i < data.length; i++) {
          repos += '<li><a href="'+data[i].html_url+'">'+htmlEscape(data[i].name)+'</a><p>'+htmlEscape(data[i].description)+'</p></li>';
        }
        target.html(repos);
      }
      return {
        showRepos: function(target){
          target = $(target);
          if (target.length == 0) return;
          var user = target.attr('data-user')
          var count = parseInt(target.attr('data-count'))
          var skip_forks = target.attr('data-skip') == 'true';
          $.ajax({
              url: "https://api.github.com/users/"+user+"/repos?callback=?"
            , dataType: 'jsonp'
            , error: function (err) { target.find('.loading').addClass('error').text("Error loading feed"); }
            , success: function(data) {
              var repos = [];
              if (!data.data) { return; }
              for (var i = 0; i < data.data.length; i++) {
                if (skip_forks && data.data[i].fork) { continue; }
                repos.push(data.data[i]);
              }
              repos.sort(function(a, b) {
                var aDate = new Date(a.pushed_at).valueOf(),
                    bDate = new Date(b.pushed_at).valueOf();

                if (aDate === bDate) { return 0; }
                return aDate > bDate ? -1 : 1;
              });

              if (count) { repos.splice(count); }
              render(target, repos);
            }
          });
        }
      };
    })()
  }
})();


$(document).ready(function() {
  octopress.wrapFlashVideos();
  octopress.testFeature(['maskImage', 'transform']);
  octopress.flashVideoFallback();
  octopress.addCodeLineNumbers();
  octopress.addMobileNav();
  octopress.addSidebarToggler();
  octopress.twitter.getFeed('#tweets')
  octopress.github.showRepos('#gh_repos');
});

var htmlEncode = (function() {
  var entities = {
    '&' : '&amp;'
    , '<' : '&lt;'
    , '"' : '&quot;'
  };

  return function(value) {
    return value.replace(/[&<"]/g, function(c) {
      return entities[c];
    });
  };
})();

// iOS scaling bug fix
// Rewritten version
// By @mathias, @cheeaun and @jdalton
// Source url: https://gist.github.com/901295
(function(doc) {
  var addEvent = 'addEventListener',
      type = 'gesturestart',
      qsa = 'querySelectorAll',
      scales = [1, 1],
      meta = qsa in doc ? doc[qsa]('meta[name=viewport]') : [];
  function fix() {
    meta.content = 'width=device-width,minimum-scale=' + scales[0] + ',maximum-scale=' + scales[1];
    doc.removeEventListener(type, fix, true);
  }
  if ((meta = meta[meta.length - 1]) && addEvent in doc) {
    fix();
    scales = [0.25, 1.6];
    doc[addEvent](type, fix, true);
  }
}(document));
