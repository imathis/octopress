require 'fileutils'

class Octopress::Commands::Create

  def initialize(project_path)
    @project_root = File.expand_path project_path
    @project_tmp = File.join @project_root, 'tmp'
    @template_root = Octopress.template_root
  end

  def execute
    FileUtils.mkdir_p @project_root
    FileUtils.cp_r File.join(@template_root, '.'), @project_root
    FileUtils.mkdir File.join(@project_root, '_posts')
    zip_file_path = download 'https://github.com/octopress/theme-classic/zipball/master', 'theme-classic.zip'
    unzip zip_file_path, @project_tmp
    extracted_root = Dir[File.join(@project_tmp, 'octopress-theme-classic-*')].first
    FileUtils.cp_r Dir.glob(File.join(extracted_root, '*')), @project_root
  end

  def read_url(url, &block)
    require 'net/http'
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

  def download(url, filename)
    FileUtils.mkdir_p @project_tmp
    File.join(@project_tmp, filename).tap do |download_path|
      File.open(download_path, 'w') do |f|
        read_url(url) { |resp| resp.read_body { |segment| f.write(segment) } }
      end
    end
  end

  def unzip(file, destination)
    require 'zip/zip'
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p File.dirname(f_path)
        zip_file.extract f, f_path unless File.exist?(f_path)
      end
    end
  end

end
