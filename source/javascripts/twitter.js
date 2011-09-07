twitter = (function($, undefined){
	
	// JSON-P Twitter fetcher for Octopress
	// (c) Brandon Mathis // MIT License

	function render(tweets, twitterUser) {
	    var template = '<li><p>{{CONTENT}}<a href="//twitter.com/{{TWITTER_USER}}/status/{{TWEET_ID}}">{{DATE}}</a></p></li>';

	    document.getElementById('tweets').innerHTML = tweets.map(function (t) {
		
	        return template.replace(/{{TWITTER_USER}}/, twitterUser)
						   .replace(/{{TWEET_ID}}/, t.id_str)
						   .replace(/{{DATE}}/, toRelativeTime(t.created_at))
						   .replace(/{{CONTENT}}/, linkifyTweet(t.text.replace(/\n/g, '<br>')));
						
						}).join('');
	}

    function linkifyTweet(text) {
        return text.replace(/(https?:\/\/)([\w\-:;?&=+.%#\/]+)/gi, '<a href="$1$2">$2</a>')
					.replace(/(^|\W)@(\w+)/g, '$1<a href="http://twitter.com/$2">@$2</a>')
					.replace(/(^|\W)#(\w+)/g, '$1<a href="http://search.twitter.com/search?q=%23$2">#$2</a>');
    }

   function toRelativeTime(time_value) {
       var values = time_value.split(" ");
       time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
       var parsed_date = Date.parse(time_value);
       var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
       var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
       delta = delta + (relative_to.getTimezoneOffset() * 60);
       if (delta < 60) {
           return 'less than a minute ago';
       } else if (delta < 120) {
           return 'about a minute ago';
       } else if (delta < (60 * 60)) {
           return (parseInt(delta / 60)).toString() + ' minutes ago';
       } else if (delta < (120 * 60)) {
           return 'about an hour ago';
       } else if (delta < (24 * 60 * 60)) {
           return 'about ' + (parseInt(delta / 3600)).toString() + ' hours ago';
       } else if (delta < (48 * 60 * 60)) {
           return '1 day ago';
       } else {
           return (parseInt(delta / 86400)).toString() + ' days ago';
       }
   }

	return {

	    getFeed: function (user, count, replies) {
	
	        var feed = new jXHR(),
	            url = "//twitter.com/statuses/user_timeline/{{USER}}.json?trim_user=true&count=60&callback=?".replace(/{{USER}}/, user);
	        count = parseInt(count, 10) || 5;

	        feed.onerror = function (msg, url) {
	            $('#tweets li.loading').addClass('error').text("Twitter's busted");
	        };
	        feed.onreadystatechange = function (data) {
	            if (feed.readyState === 4) {

	                var tweets = [];

	                for (var i in data) {
	                    if (tweets.length < count) {
	                        if (replies || data[i].in_reply_to_user_id === null) {
	                            tweets.push(data[i]);
	                        }
	                    }
	                }

	                render(tweets, user);
	            }
	        };

	        feed.open("GET", url);
	        feed.send();
	    }
	};

}($));
