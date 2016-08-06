# encoding: utf-8

# Available _config.yml settings :
# - category_overall_index_title:   The title for categories overall index page

module Jekyll
  class CategoryOverallIndex < Page

    # Initializes a new CategoryIndex.
    #
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, category_dir, categories)
      @site = site
      @base = base
      @dir = category_dir
      @name = 'index.html'
      self.process(@name)
      # Read the YAML data from the layout page.
      self.read_yaml(File.join(base, '_layouts'), 'category_overall_index.html')

      self.data['categories'] = categories

      # Set the title for this page.
      self.data['title'] = site.config['category_overall_index_title'] || "Categories"
      # Set the meta-description for this page.
      self.data['description'] = site.config['category_overall_index_title'] || "Categories"

    end
  end

  # Monkey Patch for generate category overall index
  class Site
    def write_category_overall_index
      if self.layouts.key? 'category_overall_index'
        index = CategoryOverallIndex.new(self, self.source, self.config['category_dir'], self.categories)
        index.render(self.layouts, site_payload)
        index.write(self.dest)
        self.pages << index
      else
        throw "No 'category_overall_index' layout found."
      end
    end
  end

  class GenerateCategoryOverallIndex < Generator
    safe true
    priority :low

    def generate(site)
      site.write_category_overall_index
    end

  end

  module Filters
    def category_url(category)
      category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase
    end

    def length(array)
      array.length
    end
  end
end