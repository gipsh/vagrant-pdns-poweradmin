# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "pdnstest"

  forward_port = ->(guest, host = guest, protocol = 'tcp') do
    config.vm.network :forwarded_port,
      guest: guest,
      host: host,
      protocol: protocol,
      auto_correct: true
  end
  
  config.vm.synced_folder "./", "/var/www/html"


  forward_port[3306]     
  forward_port[80, 48080] 
  forward_port[53, 53, 'udp']
  forward_port[53, 53, 'tcp']

  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.provision "shell", path: "install.sh"
end
