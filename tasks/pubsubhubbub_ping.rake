config = Octopress.config

desc "Notify pubsubhubbub hub of new content"
task :pubsubhubbub_ping do
  raise "!! No hub URL specified (please specify hub_url in _config.yml)" unless config['hub_url']
  require 'net/http'
  require 'uri'
  atom_url = config['url'] + "/atom.xml"
  resp, data = Net::HTTP.post_form(URI.parse(config['hub_url']),
                                   {'hub.mode' => 'publish',
                                    'hub.url' => atom_url})
  raise "!! Hub notification error: #{resp.code} #{resp.msg}, #{data}" unless resp.code == "204"
  puts "## Notified hub (" + config['hub_url'] + ") that feed #{atom_url} has been updated"
end
