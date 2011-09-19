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
Here's an example for deploying the Octopress website to Github Project Pages:

``` sh
    # _config.yml
    destination: public/octopress
    url: http://imathis.github.com/octopress
    subscribe_rss: /octopress/atom.xml
    root: /octopress

    # config.rb - for Compass & Sass
    http_path = "/octopress"
    http_images_path = "/octopress/images"
    http_fonts_path = "/octopress/fonts"
    css_dir = "public/octopress/stylesheets"

    # Rakefile
    public_dir = "public/octopress"
    # If deploying with rsync, update your Rakefile path
    document_root = "~/yoursite.com/your/path"
```
