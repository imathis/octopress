#require 'aruba/cucumber'

def run_command(cmd)
  Dir.chdir @dir do
    puts `CURRENT_DIR="#{@dir}" #{cmd}`
  end
end

def posts
  posts_dir = File.join(@dir, 'source', '_posts')
  Dir["#{posts_dir}/**/*"].sort
end

def test_page
  File.join(@dir, 'source', 'new-page', 'index.markdown')
end