The key source directories are as follows:

    source/
      _includes/    # Main layout partials
        custom/     # <- Customize head, navigation, footer, and sidebar here
        asides/     # Theme sidebar partials
        post/       # post metadata, sharing & comment partials
      _layouts/     # layouts for pages, posts & category archives

It's pretty likely you'll create pages and want to add them to the main navigation partial. In the latest (version 2.1)  To do that

Beyond that, I don't expect there to be a great need to change the markup very much, since the HTML is flexible and semantic and most common
customizations be taken care of [with configuration](/docs/configuring).

If you study the layouts and partials, you'll see that there's a lot of conditional markup. Logic in the view is lamentable, but a necessary
side effect of simple static site generation.
