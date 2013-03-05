# Tag Cloud for Octopress, modified by pf_miles, for use with utf-8 encoded blogs(all regexp added 'u' option).
# modified by alswl, tag_cloud -> category_cloud
# =======================
#
# Description:
# ------------
# Easy output tag cloud and category list.
#
# Syntax:
# -------
#     {% tag_cloud [counter:true] %}
#     {% category_list [counter:true] %}
#
# Example:
# --------
# In some template files, you can add the following markups.
#
# ### source/_includes/custom/asides/tag_cloud.html ###
#
#     <section>
#       <h1>Tag Cloud</h1>
#         <span id="tag-cloud">{% tag_cloud %}</span>
#     </section>
#
# ### source/_includes/custom/asides/category_list.html ###
#
#     <section>
#       <h1>Categories</h1>
#         <ul id="category-list">{% category_list counter:true %}</ul>
#     </section>
#
# Notes:
# ------
# Be sure to insert above template files into `default_asides` array in `_config.yml`.
# And also you can define styles for 'tag-cloud' or 'category-list' in a `.scss` file.
# (ex: `sass/custom/_styles.scss`)
#
# Licence:
# --------
# Distributed under the [MIT License][MIT].
#
# [MIT]: http://www.opensource.org/licenses/mit-license.php
#
module Jekyll

  class CategoryCloud < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      @opts = {}
      if markup.strip =~ /\s*counter:(\w+)/iu
        @opts['counter'] = ($1 == 'true')
        markup = markup.strip.sub(/counter:\w+/iu,'')
      end
      super
    end

    def render(context)
      lists = {}
      max, min = 1, 1
      config = context.registers[:site].config
      category_dir = config['root'] + config['category_dir'] + '/'
      categories = context.registers[:site].categories
      categories.keys.sort_by{ |str| str.downcase }.each do |category|
        count = categories[category].count
        lists[category] = count
        max = count if count > max
      end

      html = ''
      lists.each do | category, counter |
        url = category_dir + category.gsub(/_|\P{Word}/u, '-').gsub(/-{2,}/u, '-').downcase
        style = "font-size: #{100 + (60 * Float(counter)/max)}%"
        html << "<a href='#{url}' style='#{style}'>#{category}"
        if @opts['counter']
          html << "(#{categories[category].count})"
        end
        html << "</a> "
      end
      html
    end
  end

  class CategoryList < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      @opts = {}
      if markup.strip =~ /\s*counter:(\w+)/iu
        @opts['counter'] = ($1 == 'true')
        markup = markup.strip.sub(/counter:\w+/iu,'')
      end
      super
    end

    def render(context)
      html = ""
      config = context.registers[:site].config
      category_dir = config['root'] + config['category_dir'] + '/'
      categories = context.registers[:site].categories
      categories.keys.sort_by{ |str| str.downcase }.each do |category|
        url = category_dir + category.gsub(/_|\P{Word}/u, '-').gsub(/-{2,}/u, '-').downcase
        html << "<li><a href='#{url}'>#{category}"
        if @opts['counter']
          html << " (#{categories[category].count})"
        end
        html << "</a></li>"
      end
      html
    end
  end

end

Liquid::Template.register_tag('category_cloud', Jekyll::CategoryCloud)
Liquid::Template.register_tag('category_list', Jekyll::CategoryList)
