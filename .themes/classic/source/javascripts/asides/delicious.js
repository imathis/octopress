// Octopress Namespace
var Octopress = Octopress || {};

Octopress.delicious = function(options) {
  var opts = {
    count:  3,
    target: '#delicious'
  };
  opts = Octopress.extend(opts, options);
  if (!opts.username || opts.username === '') {
    throw 'Requires option `username`';
  }

  function render(items) {
    var output = '';
    for (var i=0,l=items.length; i<l; i++) {
      var tags = (items[i].t.length > 0) ? 'Tags: ' + items[i].t.join(', ') : '';
      output += '<li><a href="' + items[i].u + '" title="' + tags + '">' + items[i].d + '</a></li>';
    }
    return output;
  }

  $.ajax({
    url:     'http://feeds.delicious.com/v2/json/' + opts.username + '?count=' + opts.count + '&sort=date&callback=?',
    type:    'jsonp',
    error:   function (err) { $( opts.target + 'li.loading' ).addClass( 'error' ).text( 'Error loading bookmarks' ); },
    success: function(data) { $( opts.target ).html( render(data) ); }
  });
};

