/*jslint indent: 2, browser: true */
/*globals $: false */

$(document).ready(function() {
  "use strict";

  var contentArea = $('#pinboard_linkroll'),
    json_URL = "http://feeds.pinboard.in/json/v1/u:" + contentArea.data('pinboard-user') + "/?count=" + contentArea.data('pinboard-count');

  $.ajax(json_URL, {
    dataType: 'jsonp',
    jsonp: 'cb',
    success: function(data) {
      var contentArea = $('#pinboard_linkroll'), item, tag, content, subContent, i, j;

      for (i = 0; i < data.length; i += 1) {
        item = data[i];
        if (item) {
          content = $('<div>').addClass('pin-item');
          subContent = $('<p>').append(
            $('<a>').
              addClass('pin-title').
              attr('href', item.u).
              text(item.d).
              append($('<br/>'))
          );

          if (item.n) {
            subContent.append(
              $('<span>').
                addClass('pin-description').
                text(item.n).
                append($('<br/>'))
            );
          }

          for (j = 0; j < item.t.length; j += 1) {
            tag = item.t[j];
            subContent.append(
              $('<a>').
                addClass('pin-tag').
                attr('href', "http://pinboard.in/u:" + encodeURIComponent(item.a) + "/t:" + encodeURIComponent(tag)).
                text(tag)
            ).append(" ");
          }
          content.append(subContent);
        }
        contentArea.append(content);
      }
    }
  });
});
