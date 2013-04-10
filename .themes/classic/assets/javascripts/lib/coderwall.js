/*jslint browser: true, devel: true, indent: 2 */
/*global jQuery: false */
(function($) {
  "use strict";
  var jsonURLTemplate = "http://coderwall.com/:username.json?source=jqcw&callback=?",
    profileURLTemplate = "http://coderwall.com/:username",
    defaults = {
      username: null,
      width: 65,
      orientation: "vertical"
    };
  $.fn.coderwall = function() {
    $(".coderwall").each(function() {
      var $this = $(this),
        username = $this.attr("data-coderwall-username") || defaults.username,
        size = $this.attr("data-coderwall-badge-width") || defaults.width,
        orientation = $this.attr("data-coderwall-orientation") || defaults.orientation,
        jsonURL = jsonURLTemplate.replace(/:username/, username),
        profileURL = profileURLTemplate.replace(/:username/, username);
      $this.addClass("coderwall-root").addClass(orientation);
      $.getJSON(jsonURL, function(result) {
        $(result.data.badges).each(function() {
          var t = $("<a/>").attr({ href: profileURL }),
            i = $("<img/>").addClass("coderwall-badge").attr({
              src: this.badge,
              width: size,
              height: size,
              alt: this.description,
              title: this.description
            });
          t.append(i);
          $this.append(t);
        });
      });
    });
  };
  $(function() {
    $(".coderwall").coderwall();
  });
}(jQuery));
