window.pxembed = {};

window.pxembed._bind = function(func, context) {
  var args, bound, slice;
  slice = Array.prototype.slice;

  if (Function.prototype.bind && func.bind === Function.prototype.bind) {
    return Function.prototype.bind.apply(func, slice.call(arguments, 1));
  }

  args = slice.call(arguments, 2);

  return bound = function() {
    if (!(this instanceof bound)) return func.apply(context, args.concat(slice.call(arguments)));
    var ctor = function(){};
    ctor.prototype = func.prototype;
    var self = new ctor;
    ctor.prototype = null;
    var result = func.apply(self, args.concat(slice.call(arguments)));
    if (Object(result) === result) return result;
    return self;
  };
};

window.pxembed.findElementWith = function (nodeList, predicate) {
  for (var i = 0; i < nodeList.length; ++i)
    if (predicate(nodeList[i])) return nodeList[i];
  return null;
};

window.pxembed.pxImagePredicate = function (image) {
  var parser = document.createElement("a");
  parser.href = image.src;
  return parser.hostname.match("500px");
}

window.pxembed.createBasicEmbeddable = function() {
  var el;
  el = document.createElement("iframe");
  el.style.display = "none";
  el.style.overflow = "hidden";
  el.style.border = "none";
  el.frameborder = "0";
  el.scrolling = "no";
  return el;
};

window.pxembed.onWindowResize = function() {
  var el, newWidth, prefWidth, _i, _len, _ref;
  _ref = window.pxembed.references;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    el = _ref[_i];
    prefWidth = el.clientWidth;
    newWidth = el.parentNode.clientWidth;
    el.style.width = "" + newWidth + "px";
    el.style.height = "" + ((newWidth / (prefWidth * 1.0)) * el.clientHeight) + "px";
  }
  return true;
};

window.pxembed.onBasicImageLoad = function (anchor, embedElement, replacement) {
  var imageElement, replacementWidth, replacementHeight;

  imageElement = window.pxembed.findElementWith(embedElement.getElementsByTagName("img"), window.pxembed.pxImagePredicate);

  replacementWidth = parseInt(imageElement.getAttribute("width") || imageElement.style.width || anchor.clientWidth);
  replacementHeight = (imageElement.height / imageElement.width) * replacementWidth;

  replacement.style.width = "" + replacementWidth + "px";
  replacement.style.height = "" + replacementHeight + "px";

  replacement.style.removeProperty("display");
  anchor.removeChild(embedElement);

  return true;
};

window.pxembed.onEmbeddedLoad = function(anchor, embedElement, replacement) {
  var imageElement;

  imageElement = window.pxembed.findElementWith(embedElement.getElementsByTagName("img"), window.pxembed.pxImagePredicate);

  if (imageElement.complete || imageElement.readyState === "complete") {
    window.pxembed.onBasicImageLoad(anchor, embedElement, replacement);
  } else {
    imageElement.onload = window.pxembed._bind(window.pxembed.onBasicImageLoad, this, anchor, embedElement, replacement);
  }

  return true;
};

window.pxembed.init = (function() {
  var anchor, createBasicEmbeddable, embedElement, embeddedPhotos, onEmbeddedLoad, photoId, replacement, _i, _len;
  if (window.pxembed.references || /MSIE (5|6|7|8)/i.test(navigator.userAgent)) {
    return false;
  }

  window.pxembed.references = [];

  embeddedPhotos = document.getElementsByClassName("pixels-photo");

  for (_i = 0, _len = embeddedPhotos.length; _i < _len; _i++) {
    embedElement = embeddedPhotos[_i];
    anchor = embedElement.parentNode;
    var linksInsideEmbed = embedElement.getElementsByTagName("a");
    var attributionLink = window.pxembed.findElementWith(linksInsideEmbed, function (href) { return href.hostname.match("500px.com"); });
    if (attributionLink == null) { continue; }
    replacement = window.pxembed.createBasicEmbeddable();
    replacement.onload = window.pxembed._bind(window.pxembed.onEmbeddedLoad, this, anchor, embedElement, replacement);
    replacement.src = attributionLink.href.replace(/(\/photo\/\d+)(\/.*)?/, "$1/embed").replace(/^http:/, "https:")
    anchor.insertBefore(replacement, embedElement);
    window.pxembed.references.push(replacement);
  }

  if(window.attachEvent) {
    window.attachEvent('onresize', window.pxembed.onWindowResize);
  } else {
    window.addEventListener('resize', window.pxembed.onWindowResize);
  }

  return true;
});

if (document.readyState == "complete") {
  window.pxembed.init();
} else {
  if (window.attachEvent) {
    window.attachEvent("onload", window.pxembed.init);
  } else {
    window.addEventListener("load", window.pxembed.init);
  }
}
