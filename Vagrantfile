# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
#!/usr/bin/env bash

echo "- bootstrapping node"
apt-get install -qq --force-yes build-essential ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 libopenssl-ruby1.9.1 nginx 1> /dev/null

echo "- installing gem requirements"
cd /blog
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install --quiet --no-ri --no-rdoc bundler 1> /dev/null
bundle install 1> /dev/null

if [ ! -d /blog/source ] || [ ! -d /blog/public ]; then
  rake install
  rake generate
fi

echo "- setting up nginx"
cat > /etc/nginx/sites-available/default <<'EOF'
server {
  listen   4001;
  root /blog/public;
  index index.html index.htm;
}
EOF

ps cax | grep 'nginx' > /dev/null
if [ $? -ne 0 ]; then service nginx start 1> /dev/null; fi
service nginx reload 1> /dev/null

echo -e "- blog is running! run further commands using:\n"
echo -e "    vagrant ssh -c 'cd /blog && rake COMMAND'\n"

echo -e "- to access the blog, please go to:\n"
echo "    rake serve (manually run): http://127.0.0.1:4000"
echo -e "    nginx (always on): http://127.0.0.1:4001\n"

echo -e "- if serving the app hangs, you may want to run:\n"
echo -e "    vagrant ssh -c 'cd /blog && pkill ruby 1.9.1'\n"

echo -e "- Available commands:\n"
rake -T | sed "s/^/    /"
SCRIPT


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.network :forwarded_port, guest: 4001, host: 4001

  config.vm.provision :shell, inline: $script

  config.vm.synced_folder "./", "/blog"

  # config.vm.network :private_network, ip: "192.168.33.10"
end
