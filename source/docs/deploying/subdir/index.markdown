---
layout: page
title: "Deploying to a Subdirectory"
date: 2011-09-10 17:53
sidebar: false
footer: false
---

If you're deploying to a subdirectory on your site, or if you're using Github's project pages, make sure you set up your urls correctly in your configs.
You can do this *almost* automatically:

``` sh
    rake set_root_dir[your/path]

    # To go back to publishing to the document root
    rake set_root_dir[/]
```

Then update your `_config.yml` and `Rakefile` as follows:

``` sh
    # _config.yml
    url: http://yoursite.com/your/path

    # Rakefile (if deploying with rsync)
    document_root = "~/yoursite.com/your/path"
```

To manually configure deployment to a subdirectory, you'll change `_config.yml`, `config.rb` and `Rakefile`.
Here's an example for deploying a site to the /awesome subdirectory:

``` sh
    # _config.yml
    destination: public/awesome
    url: http://example.com/awesome
    subscribe_rss: /awesome/atom.xml
    root: /awesome

    # config.rb - for Compass & Sass
    http_path = "/awesome"
    http_images_path = "/awesome/images"
    http_fonts_path = "/awesome/fonts"
    css_dir = "public/awesome/stylesheets"

    # Rakefile
    public_dir = "public/awesome"
    # If deploying with rsync, update your Rakefile path
    document_root = "~/yoursite.com/awesome"
```
