// Octopress Namespace
var Octopress = Octopress || {};

Octopress.github = function(options) {
  var opts = {
    target: '#github'
  };
  opts = Octopress.extend(opts, options);
  if (!opts.username || opts.username === '') {
    throw 'Requires option `username`';
  }

  function render(repos) {
    var output = '';
    for (var i=0,l=repos.length; i<l; i++) {
      output += '<li><a href="' + repos[i].url + '">' + repos[i].name + '</a><p>' + repos[i].description + '</p></li>';
    }
    return output;
  }

  function parseResult(data) {
    var repos = [];
    for (var i=0, len=data.repositories.length; i < len; i++) {
      if (opts.skip_forks && data.repositories[i].fork) { continue; }
      repos.push(data.repositories[i]);
    }
    repos.sort(function(a, b) {
      var aDate = new Date(a.pushed_at).valueOf(),
          bDate = new Date(b.pushed_at).valueOf();

      if (aDate === bDate) { return 0; }
      return aDate > bDate ? -1 : 1;
    });

    if (opts.count) { repos.splice(opts.count); }
    return repos;
  }

  $.ajax({
    url:     'http://github.com/api/v2/json/repos/show/' + opts.username + '?callback=?',
    type:    'jsonp',
    error:   function (err) { $( opts.target + ' li.loading' ).addClass( 'error' ).text( 'Error loading repositories' ); },
    success: function(data) {
      var repos = parseResult(data);
      $( opts.target ).html( render(repos) );
    }
  });
};
