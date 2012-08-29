require 'pygments'
require 'fileutils'
require 'digest/md5'

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module HighlightCode
  def highlight(str, lang)
    lang = 'ruby' if lang == 'ru'
    lang = 'objc' if lang == 'm'
    lang = 'perl' if lang == 'pl'
    lang = 'yaml' if lang == 'yml'
    str = pygments(str, lang).match(/<pre>(.+)<\/pre>/m)[1].to_s.gsub(/ *$/, '') #strip out divs <div class="highlight">
    tableize_code(str, lang)
  end

  def pygments(code, lang)
    if defined?(PYGMENTS_CACHE_DIR)
      path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest(code)}.html")
      if File.exist?(path)
        highlighted_code = File.read(path)
      else
        highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
        File.open(path, 'w') {|f| f.print(highlighted_code) }
      end
    else
      highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
    end
    highlighted_code
  end
  def tableize_code (str, lang = '')
    table = '<div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers">'
    code = ''
    str.lines.each_with_index do |line,index|
      table += "<span class='line-number'>#{index+1}</span>\n"
      code  += "<span class='line'>#{line}</span>"
    end
    table += "</pre></td><td class='code'><pre><code class='#{lang}'>#{code}</code></pre></td></tr></table></div>"
  end
end

#------------------------------------------------------------------------------#
# INTERIM BUGFIX FOR: https://github.com/imathis/octopress/issues/704
# an upstream solution is in the works but, as of 2012-08-29, the pygment.rb
# gem has yet to incorporate necessary changes and release a new gem:
# https://github.com/tmm1/pygments.rb/issues/10
#
# The ForcePython2 module below tries to ensure that, when the 'python' command
# is executed, it always returns an interpreter for version 2.* of python,
# regardless of what the system-wide default version of python is.  When the
# system-wide version of python is not 2.* and a compatible version is found,
# a .pygments-cache/python-bin/python symlink is created which points to the
# compatible version.  The python-bin directory is then added to the PATH
# which gives priority to locally identified version.
#
module ForcePython2
  class << self
    def find_python2
      (%w{python python2} + 10.downto(0).map{|v|"python2.#{v}"}).each do |cmd|
        cmd_path = which_cmd(cmd) or next
        return cmd_path if python_major_ver(cmd_path) == 2
      end
      nil
    end

    def python_major_ver(cmd_path)
      %x{"#{cmd_path}" -c "import sys; print(sys.version_info.major)"}.to_i
    end

    def which_cmd(cmd)
      # loosely based on cross-platform solution found on stack overflow:
      # http://stackoverflow.com/questions/2108727/
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : [''] # windows
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        cmd_paths = exts.map {|ext| "#{path}#{File::SEPARATOR}#{cmd}#{ext}" }
        cmd_path = cmd_paths.find {|c| File.executable?(c) }
        return cmd_path if cmd_path
      end
      nil
    end

    def force
      # rewrite PATH to include local dir which might have python symlink
      path = "#{PYGMENTS_CACHE_DIR}#{File::SEPARATOR}python-bin"
      ENV['PATH'] = "#{path}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

      # if 'python' command's version is 2.*, we're good
      return if python_major_ver(which_cmd('python')) == 2

      # not v2, search all our paths for a compatible version
      if cmd_path = find_python2
        # found a compatible version, make it stick w/ a symlink
        sym_path = "#{path}#{File::SEPARATOR}python#{File.extname(cmd_path)}"
        FileUtils.mkdir_p(path)
        File.symlink(cmd_path, sym_path) rescue nil # don't care if unimplemented
      end
    end

  end
end

ForcePython2::force unless ENV['FORCE_PYTHON2'] =~ /^(?:0|false|no)$/i
