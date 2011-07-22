---
layout: page
title: Configuring Octopress
date: July 19 2011
sidebar: false
footer: false
---

[&laquo; Previous, Deploying Octopress](/docs/deploy)

I've tried to keep configuring Octopress fairly simple and you'll probably only ever change the `Rakefile` and the `_config.yml`.
Here's a list of files for configuring Octopress.

{% codeblock %}
_config.yml       # Main config (Jekyll's settings)
Rakefile          # Configs for deployment
config.rb         # Compass config
config.ru         # Rack config
{% endcodeblock %}

Configurations in the `Rakefile` are mostly related to deployment and you probably won't have to touch them unless you're using rsync.

## Blog Configuration

In the `_config.yml` there are three sections for configuring your Octopress Blog.
**Spoiler:** You'll probably only change `url`, `title`, `subtitle` and `author` and enable some 3rd party services.

### Main Configs

{% codeblock %}
url:                # For rewriting URLs for RSS, etc
title:              # Used in the header and title tags

subtitle:           # A description used in the header
author:             # Your name, for RSS, Copyright, Metadata
simple_search:      # Search engine for simple site search
subscribe_rss:      # URL for your blog's feed, defauts to /atom.xml
subscribe_email:    # URL to subscribe by email (service required)
email:              # Email address for the RSS feed if you want it.
{% endcodeblock %}

**Note:** If your site is a multi-author blog, you may want to set this config's `author` to the name of your
company or project, and add author metadata to posts and pages to give proper attribution for those works.

### Jekyll & Plugins
These configurations are used by Jekyll and Plugins. If you're not familiar with Jekyll, you should probably have a look at the [configuration docs](https://github.com/mojombo/jekyll/wiki/Configuration) which lists more options that aren't covered here.

{% codeblock %}
root:             # Mapping for relative urls (default: /)
port:             # Port to mount Jekyll's webbrick server
permalink:        # Permalink structure for blog posts
source:           # Directory for site source files
destination:      # Directory for generated site files
plugins:          # Directory for Jekyll plugins
code_dir:         # Directory for code snippets (for include_code plugin)
category_dir:     # Directory for generated blog category pages
pygments:         # Toggle pygments syntax highlighting
paginate:         # Posts per page on the blog index
recent_posts:     # Number of recent posts to appear in the sidebar
{% endcodeblock %}

If you want to change the way permalinks are written for your blog posts, see [Jekyll's permalink docs](https://github.com/mojombo/jekyll/wiki/Permalinks).

**Note:** Jekyll has a `baseurl` config which adds a redirect for Jekyll's webbrick server for shallow subdirectory support.
Octopress uses the `root` configuration and offers a rake task `set_root_dir[/some/directory]` to update configs and move exported files to the subdirectory [(see Deploying Octopress)](/docs/deploying).
In other words, don't use `baseurl` use `root`.

### 3rd Party Settings
These third party integrations are already set up for you. Simply fill in the configurations and they'll be added to your site.

- **Twitter** - Setup a sidebar twitter feed, follow button, and tweet button (for sharing posts and pages).
- **Google Plus One** - Setup sharing for posts and pages on Google's plus one network.
- **Pinboard** - Share your recent Pinboard bookmarks in the sidebar.
- **Delicious** - Share your recent Delicious bookmarks in the sidebar.
- **Disqus Comments** - Add your disqus short name to enable disqus comments on your site.
- **Google Analytics** - Add your tracking id to enable Google Analytics tracking for your site.

[Next, Blogging With Octopress &raquo;](/docs/blogging)
