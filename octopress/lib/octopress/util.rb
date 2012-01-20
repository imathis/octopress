require 'net/http'
require 'fileutils'
require 'tempfile'
require 'zip/zip'

module Octopress::Util

  def download(url, dir, filename=nil)
    download_path = nil
    read_url(url) do |response|
      if !filename && response['content-disposition'].to_s =~ /filename=(.*);?/
        filename = $1
      end
      filename ||= File.basename(url)
      download_path = File.join(dir, filename)

      FileUtils.mkdir_p dir
      File.open(download_path, 'w') do |file|
        response.read_body {|segment| file.write(segment)}
      end
    end
    download_path
  end

  # Unzip the file at path into dir. Assumes that the Zip file has a single
  # root directory, answering the path to it.
  #
  def unzip(path, destdir)
    root = nil
    Zip::ZipFile.open(path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destdir, f.name)
        root ||= f_path
        FileUtils.mkdir_p File.dirname(f_path)
        zip_file.extract f, f_path unless File.exist?(f_path)
      end
    end
    root
  end

  def read_url(url, &block)
    success_response, limit, tries = false, 5, 0
    uri = URI(url)
    until success_response || tries == limit
      tries += 1
      Net::HTTP.start(uri.host, uri.port, use_ssl:(uri.scheme == 'https')) do |http|
        http.request_get(uri.path) { |response|
          case response
          when Net::HTTPRedirection
            success_response = false
            uri = URI(response['location'])
          when Net::HTTPSuccess
            success_response = true
            block.call response
          end
        }
      end
    end
  end

end
