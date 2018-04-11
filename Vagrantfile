# -*- mode: ruby -*-
# vi: set ft=ruby :

# Number of nodes
NODE_COUNT = 3

if(NODE_COUNT!=3 && NODE_COUNT!=5)
    raise Vagrant::Errors::VagrantError.new, "Invalid node count, there should only be 3 or 5 nodes"
end

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
          s.path = "provision/node.sh"
          s.args   = ["node#{i}","172.20.20.#{i}0","172.20.20.10","172.20.20.#{NODE_COUNT}0"]
      end
    end
  end

  config.vm.define "slave" do |subconfig|
    subconfig.vm.hostname = "slave"
    subconfig.vm.network "private_network", ip: "172.20.20.100"
    subconfig.vm.provision "shell" do |s|
        s.path = "provision/slave.sh"
        s.args   = []
    end
  end

end
