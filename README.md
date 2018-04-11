# vault-consult-vagrant

Proof of concept for a HA Cluster of Vault servers with consul backends. 

## Installation

Just start all machines with `vagrant up`.

## Initialize and unseal Vault

Log into the master node with `vagrant ssh node1` and run the following commands to initialize Vault:
```
sudo su
vault operator init
```
Vault will now be initialized. After that you will see a list of 5 Unseal keys and an Initial Root Token. You will need the Unseal keys to unseal Vault everytime you restart a server, so make sure you don't loose them. Otherwise you won't be able to unseal Vault again.

With the unseal keys you can now start the process of unsealing. To unseal Vault, run `vault operator unseal` and enter 1 Unseal key. Use a different key each time you run the `unseal` command. You will have to unseal each server independently. Log into the other nodes with `vagrant ssh node[2|3|4|5]` and run:
```
sudo su
```
And repeat the `vault operator unseal` procedure 3 times.

## Check if everything is working

Start a browser and open http://172.20.20.10:8500/. You will see an overview of your consul and vault servers and their status.

## What to do next?

Check the documentations at https://www.consul.io/docs/ and https://www.vaultproject.io/docs/ for more information on how to configure Consul and Vault.
