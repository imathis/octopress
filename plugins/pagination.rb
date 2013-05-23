module Jekyll
  class Pager
    # Determine if pagination is enabled for a given file.
    #
    # config - The configuration Hash.
    # page   - The Jekyll::Page with which to paginate
    #
    # Returns true if pagination is enabled, false otherwise.
    def self.pagination_enabled?(config, page)
     !config['paginate'].nil? &&
        page.name == 'index.html' &&
        page.dir == '/'
    end

    # Static: Return the pagination path of the page
    #
    # site_config - the site config
    # num_page - the pagination page number
    #
    # Returns the pagination path as a string
    def self.paginate_path(site_config, num_page)
      return nil if num_page.nil? || num_page <= 1
      format = site_config['paginate_path']
      format = format.sub(':num', num_page.to_s)
    end
  end
end
