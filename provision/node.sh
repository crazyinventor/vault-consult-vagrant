#!/bin/bash

# Update /etc/hosts
echo $2 $1 >> /etc/hosts

# Get the necessary utilities and install them.
apt-get update
apt-get install -y unzip supervisor software-properties-common logrotate

# Create a Consul user.
id -u consul &>/dev/null || useradd -r -M consul

# Make the Consul directory.
mkdir -p /etc/consul.d
mkdir -p /var/consul
# Make the Vault config directory.
mkdir -p /etc/vault

# Make Consul user owner of consul directory.
chown consul /var/consul

# Copy the supervisor for consul config to the /etc/supervisor/conf.d folder.
cp /vagrant/config/consul/supervisor.conf /etc/supervisor/conf.d/consul_server.conf
# Copy the supervisor for vault config to the /etc/supervisor/conf.d folder.
cp /vagrant/config/vault/supervisor.conf /etc/supervisor/conf.d/vault_server.conf

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

# Install Vault binaries
if [ ! -f /usr/local/bin/vault ]; then
  if [ ! -f /vagrant/tmp/vault ]; then
    cd /vagrant/tmp
    wget --progress=bar:force -O vault.zip https://releases.hashicorp.com/vault/0.9.5/vault_0.9.5_linux_amd64.zip
    unzip vault.zip
    rm vault.zip
  fi
  cp /vagrant/tmp/vault /usr/local/bin/
fi

# Copy the consul server configuration.
if [ $1 = "node1" ]; then
  cp /vagrant/config/consul/master.json /etc/consul.d/config.json
else
  cp /vagrant/config/consul/node.json /etc/consul.d/config.json
  sed -i -e "s/RANGE_START/$3/g" /etc/consul.d/config.json
  sed -i -e "s/RANGE_END/$4/g" /etc/consul.d/config.json
fi
sed -i -e "s/NODE_IP/$2/g" /etc/consul.d/config.json

# Copy the vault server configuration.
cp /vagrant/config/vault/vault.hcl /etc/vault/vault.hcl
sed -i -e "s/NODE_IP/$2/g" /etc/vault/vault.hcl

# Create TLS certificate
openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout /etc/vault/vault.key -out /etc/vault/vault.crt -subj "/C=CH/ST=St. Gallen/L=Rapperswil/O=bexio AG/OU=DevOps/CN=$1"

# Restart supervisor to start consul and vault
/etc/init.d/supervisor restart

# Add Vault address to root's environment
echo export VAULT_ADDR="http://$1:8200" >> /root/.profile
echo export VAULT_ADDR="http://$1:8200" >> /root/.bashrc
