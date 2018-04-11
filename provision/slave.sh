#!/bin/bash

# Get the necessary utilities and install them.
apt-get update
apt-get install -y unzip

# Create a Consul user.
id -u consul &>/dev/null || useradd -r -M consul

# Make the Consul directory.
mkdir -p /etc/consul.d
mkdir -p /var/consul

# Make Consul user owner of consul directory.
chown consul /var/consul

# Install consul binaries
if [ ! -f /usr/local/bin/consul ]; then
  if [ ! -f /vagrant/tmp/consul ]; then
    cd /vagrant/tmp
    wget --progress=bar:force -O consul.zip https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
    unzip consul.zip
    rm consul.zip
  fi
  cp /vagrant/tmp/consul /usr/local/bin/
fi
