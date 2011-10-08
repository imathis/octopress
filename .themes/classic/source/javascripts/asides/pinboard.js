// Octopress Namespace
var Octopress = Octopress || {};

Octopress.pinboard = function(options) {
  var opts = {
    count:  3,
    target: '#pinboard'
  };
  opts = Octopress.extend(opts, options);
  if (!opts.username || opts.username === '') {
    throw 'Requires option `username`';
  }

  function render(items) {
    var output = '';
    for (var i in items) {
      if (!items[i].d) { return; }

      var tags = [];
      for (var tag in items[i].t) {
        var name = items[i].t[tag].replace(/^\s+|\s+$/g, '');
        if (name !== "") { tags.push( name ); }
      }
      tags = (tags.length > 0) ? 'Tags: ' + tags.join(', ') : '';

      output += '<li class="pin-item"><a class="pin-title" href="' + items[i].u + '" title="' + tags + '">' + items[i].d + '</a><br>';
      if (items[i].n) { output += '<span class="pin-description">' + items[i].n + '</span>'; }

      output += '</li>';
    }
    return output;
  }

  var cache = Octopress.cacheGet('pinboard');
  if (cache) {
    $( opts.target ).html( render(cache) );
  } else {
    $.ajax({
      url:           'http://feeds.pinboard.in/json/v1/u:' + opts.username + '?count=' + opts.count + '&format=json&cb=?',
      type:          'jsonp',
      jsonpCallback: 'cb',
      error:         function (err) { $( opts.target + 'li.loading' ).addClass( 'error' ).text( 'Error loading bookmarks' ); },
      success:       function(data) {
        $( opts.target ).html( render(data) );
        Octopress.cacheSet('pinboard', data, 300);
      }
    });
  }
};
