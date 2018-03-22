# -*- mode: ruby -*-
# vi: set ft=ruby :

# Number of nodes
NODE_COUNT = 3

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
    vb.cpus = 1
  end
  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |subconfig|
      subconfig.vm.hostname = "node#{i}"
      subconfig.vm.network "private_network", ip: "172.20.20.#{i}0"
      subconfig.vm.provision "shell" do |s|
          s.path = "provision.sh"
          s.args   = ["node#{i}","172.20.20.#{i}0","172.20.20.10","172.20.20.#{NODE_COUNT}0"]
      end
    end
  end
end
