--- 
layout: post
comments: false
title: Flickr Photo Gallery
date: 2009-3-18
link: false
categories: life
---
Recently Sibylle asked me if we could add a <a title="Elfenbein Klaviermusik Photo Gallery" href="http://sibyllekuder.com/photos.php" target="_blank">photo gallery</a> to her <a title="Elfenbein Klaviermusik" href="http://sibyllekuder.com" target="_blank">piano studio web site</a>, so that she might be able to display pictures there. I started to look at various examples but wasn't really excited about any of the templates I had found, until I read the <a title="Create a Slick Flickr Gallery with SimplePIE" href="http://net.tutsplus.com/tutorials/php/create-a-slick-flickr-gallery-with-simplepie/" target="_blank">Create a Slick Flickr Gallery with SimplePIE</a> on <a title="Nettuts" href="http://nettuts.com/" target="_blank">Nettuts.com</a>.

The tutorial shows how to use the SimplePIE RSS reader to dynamically pull pictures from your Flickr account and make a nice gallery page on your website. Want new pictures on your website? Just add new pictures to the collection or set you used as the source for the RSS feed.

I was able to get Sibylle's photographs page working in relatively little time. The one stumbling block (once I got the example page provided working with her style sheet) was dealing with pictures of varying sizes. The RSS feed from Flickr contains links to all the available image sizes for each image in the set. The gallery page uses the thumbnail size image for display; when that image is clicked the large image size is shown in a modal window. Not all of the images in the set had a large size, so clicking on their thumbnail resulted in an "image not available" message from Flickr.

Since I had the URLs for all the image sizes, I decided to see if I could test the results for the large image URL, and if it wasn't available, substitute the URL for the medium image size. The gallery page uses PHP to manipulate the images, so I did come Google searches and discovered the <strong>curl</strong> function. Using that function I was able to capture the HTTP response header from Flickr when the large image URL was used as the request. Parsing that response using the string position function, <strong>strpos</strong>, I was able to determine if the image existed or was unavailable.

The php code that does this image pre-fetch is shown below. <strong>$full_url</strong> is set to the large image size URL by the time this code is reached. <strong>$not_available</strong> is set to the image not available URL from Flickr, or http://l.yimg.com/g/images/photo_unavailable.gif. If <strong>strpos</strong> returns a value greater than zero the image isn't there, and we set <strong>$full_url</strong> to be the medium sized URL from the <strong>$img</strong> collection.

Now her gallery page automatically adjusts the modal window to display the large image if it is available, or the medium sized image if it is not. A slick Flickr gallery made even slicker.

If you are interested it the full source listing of the page, please leave a comment with a working email address and I'll be happy to send it to you.
