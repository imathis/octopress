var github = (function(){
  function render(target, data){
    var i = 0, repos = '';

    for(i = 0; i < data.length; i++) {
      repos += '<li><a href="'+data[i].html_url+'">'+data[i].name+'</a><p>'+data[i].description+'</p></li>';
    }
    target.html(repos);
  }
  return {
    showRepos: function(options){
      $.ajax({
          url: "https://api.github.com/users/"+options.user+"/repos?callback=?"
        , dataType: 'jsonp'
        , error: function (err) { options.target.find('.loading').addClass('error').text("Error loading feed"); }
        , success: function(data) {
          var repos = [];
          if (!data.data) { return; }
          for (var i = 0; i < data.data.length; i++) {
            if (options.skip_forks && data.data[i].fork) { continue; }
            repos.push(data.data[i]);
          }
          repos.sort(function(a, b) {
            var aDate = new Date(a.pushed_at).valueOf(),
                bDate = new Date(b.pushed_at).valueOf();

            if (aDate === bDate) { return 0; }
            return aDate > bDate ? -1 : 1;
          });

          if (options.count) { repos.splice(options.count); }
          render(options.target, repos);
        }
      });
    }
  };
})();

$(document).ready(function(){
  g = $('#gh_repos');

  github.showRepos({
      user: g.attr('data-user')
    , count: parseInt(g.attr('data-count'))
    , skip_forks: g.attr('data-skip') == 'true'
    , target: g
  });
});
