// iOS scaling bug fix
// By @mathias, @cheeaun and @jdalton
// Source url: https://gist.github.com/901295

var addEvent = 'addEventListener',
    type = 'gesturestart',
    qsa = 'querySelectorAll',
    scales = [1, 1],
    meta = qsa in document ? document[qsa]('meta[name=viewport]') : [];
function fix() {
  meta.content = 'width=device-width,minimum-scale=' + scales[0] + ',maximum-scale=' + scales[1];
  document.removeEventListener(type, fix, true);
}
if ((meta = meta[meta.length - 1]) && addEvent in document) {
  fix();
  scales = [0.25, 1.6];
  document[addEvent](type, fix, true);
}

