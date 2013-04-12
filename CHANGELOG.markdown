# Octopress Changelog

## 2.1

- Gist plugin now uses raw text instead of the Gist JS
- Improvements to SCSS which styles `<sup>` and `<sub>` tags (#426)
- Added list of categories into atom.xml (#421)
- Added default support for guag.es analytics (#827)
- `rake preview` binds to IP and HOST, which can be set through OCTOPRESS_IP and OCTOPRESS_HOST, respectively (#780)
- New configuration structure (#958)
- Improved draft management options
  - rake list_drafts shows current drafts.
  - Rake generate, watch, and preview can compile future dated posts (defaults to false).
- FIX: `full_configuration` in Rakefile was uninitialized (#1021)
- Site Enhancements
- Development fixes

## 2.0

- Now based on [mojombo/jekyll](http://github.com/mojombo/jekyll)
- Sports a semantic HTML5 template
- Easy theming with Compass and Sass
- A Mobile friendly responsive (320 and up) layout
- Built in 3rd party support for Twitter, Google Plus One, Disqus Comments, Pinboard, Delicious, and Google Analytics
- Deploy to Github pages or use Rsync
- Built in support for POW and Rack servers
- Beautiful [Solarized](http://ethanschoonover.com/solarized) syntax highlighting
- Super easy setup and configuration

**New Plugins, Filters, & Generators**

- **Gist Tag** for easily embedding gists in your posts
- **Pygments Cache** makes subsequent compiling much faster
- **Include Code Tag** lets you embed external code snippets from your file system and adds a download link
- **Pullquote Tag** Generate beautiful semantic pullquotes (no double data) based on Maykel Loomans's [technique](http://miekd.com/articles/pull-quotes-with-html5-and-css/)
- **Blockquote Tag** makes it easy to semantically format blockquotes
- **Category Generator** gives you archive pages for each category
- **Sitemap.xml Generator** for search engines

## 1.0

- **No longer supported.**
- Jekyll Matured, but Henrik's Jekyll fork did not.
- Thanks for all your pull requests, I learned a lot.

# HEAD
