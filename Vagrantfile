# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "pdnstest"

  forward_port = ->(guest, host = guest) do
    config.vm.network :forwarded_port,
      guest: guest,
      host: host,
      auto_correct: true
  end
  
  config.vm.synced_folder "./", "/var/www/html"


  forward_port[3306]     
  forward_port[80, 48080] 
  config.vm.network "forwarded_port", guest: 53, host: 53, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 53, host: 53, protocol: "udp"

  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.provision "shell", path: "install.sh"
end
