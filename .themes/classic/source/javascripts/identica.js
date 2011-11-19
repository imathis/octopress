// JSON-P Identica fetcher for Octopress
// (c) Brandon Mathis // MIT License

/* Sky Slavin, Ludopoli. MIT license.  * based on JavaScript Pretty Date * Copyright (c) 2008 John Resig (jquery.com) * Licensed under the MIT license.  */
function prettyDate(time) {
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

function linkifyTweet(text) {
  // Linkify urls, usernames, hashtags
  text = text.replace(/(https?:\/\/)([\w\-:;?&=+.%#\/]+)/gi, '<a href="$1$2">$2</a>')
    .replace(/(^|\W)@(\w+)/g, '$1<a href="http://identi.ca/$2">@$2</a>')
    .replace(/(^|\W)#(\w+)/g, '$1<a href="http://identi.ca/tag/$2">#$2</a>');

  return text
}

function showIdenticaFeed(tweets, identica_user) {
  var timeline = document.getElementById('notices'),
      content = '';

  for (var t in tweets) {
    content += '<li>'+'<p>'+'<a href="http://identi.ca/notice/'+tweets[t].id+'">'+prettyDate(tweets[t].created_at)+'</a>'+linkifyTweet(tweets[t].text.replace(/\n/g, '<br>'))+'</p>'+'</li>';
  }
  timeline.innerHTML = content;
}

function getIdenticaFeed(user, count, replies) {
  count = parseInt(count, 10);
  $.ajax({
      url: "http://identi.ca/api/statuses/user_timeline/" + user + ".json?trim_user=true&count=" + (count + 20) + "&exclude_replies=" + (replies ? "0" : "1") + "&callback=?"
    , type: 'jsonp'
    , error: function (err) { $('#notices li.loading').addClass('error').text("Identica's busted"); }
    , success: function(data) { showIdenticaFeed(data.slice(0, count), user); }
  })
}
