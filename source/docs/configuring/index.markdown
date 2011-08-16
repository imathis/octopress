---
layout: page
title: Configuring Octopress
date: July 19 2011
sidebar: false
footer: false
---

[&laquo; Previous, Octopress Setup](/docs/setup)

I've tried to keep configuring Octopress fairly simple and you'll probably only ever change the `Rakefile` and the `_config.yml`.
Here's a list of files for configuring Octopress.

``` sh
    _config.yml       # Main config (Jekyll's settings)
    Rakefile          # Configs for deployment
    config.rb         # Compass config
    config.ru         # Rack config
```

Configurations in the `Rakefile` are mostly related to deployment and you probably won't have to touch them unless you're using rsync.

## Blog Configuration

In the `_config.yml` there are three sections for configuring your Octopress Blog.
**Spoiler:** You must change `url`, and you'll probably change `title`, `subtitle` and `author` and enable some 3rd party services.

### Main Configs

``` yaml
    url:                # For rewriting urls for RSS, etc
    title:              # Used in the header and title tags
    subtitle:           # A description used in the header
    author:             # Your name, for RSS, Copyright, Metadata
    simple_search:      # Search engine for simple site search
    subscribe_rss:      # Url for your blog's feed, defauts to /atom.xml
    subscribe_email:    # Url to subscribe by email (service required)
    email:              # Email address for the RSS feed if you want it.
```

**Note:** If your site is a multi-author blog, you may want to set this config's `author` to the name of your
company or project, and add author metadata to posts and pages to give proper attribution for those works.

### Jekyll & Plugins
These configurations are used by Jekyll and Plugins. If you're not familiar with Jekyll, you should probably have a look at the [configuration docs](https://github.com/mojombo/jekyll/wiki/Configuration) which lists more options that aren't covered here.

``` yaml
    root:               # Mapping for relative urls (default: /)
    permalink:          # Permalink structure for blog posts
    source:             # Directory for site source files
    destination:        # Directory for generated site files
    plugins:            # Directory for Jekyll plugins
    code_dir:           # Directory for code snippets (for include_code plugin)
    category_dir:       # Directory for generated blog category pages

    pygments:           # Toggle python pygments syntax highlighting
    paginate:           # Posts per page on the blog index
    pagination_dir:     # Directory base for pagination URLs eg. /blog/page/2/
    recent_posts:       # Number of recent posts to appear in the sidebar

    default_asides:     # Configure what shows up in the sidebar and in what order
    blog_index_asides:  # Optional sidebar config for blog index page
    post_asides:        # Optional sidebar config for post layout
    page_asides:        # Optional sidebar config for page layout
```

If you want to change the way permalinks are written for your blog posts, see [Jekyll's permalink docs](https://github.com/mojombo/jekyll/wiki/Permalinks).

**Note:** Jekyll has a `baseurl` config which offers mock subdirectory publishing support by adding a redirect to Jekyll's WEBrick server. **Please don't use this.**
If you want to publish your site to a subdirectory, [(see Deploying Octopress to a Subdirectory)](/docs/deploying/#deploy_subdir).

<h3 id="third_party">3rd Party Settings</h3>
These third party integrations are already set up for you. Simply fill in the configurations and they'll be added to your site.

- **Twitter** - *Setup a sidebar twitter feed, follow button, and tweet button (for sharing posts and pages).*
- **Google Plus One** - *Setup sharing for posts and pages on Google's plus one network.*
- **Pinboard** - *Share your recent Pinboard bookmarks in the sidebar.*
- **Delicious** - *Share your recent Delicious bookmarks in the sidebar.*
- **Disqus Comments** - *Add your disqus short name to enable disqus comments on your site.*
- **Google Analytics** - *Add your tracking id to enable Google Analytics tracking for your site.*

The Octopress layouts read these configurations and only include the javascript and html necessary for the enabled services.

[Next, Blogging with Octopress &raquo;](/docs/blogging/)
