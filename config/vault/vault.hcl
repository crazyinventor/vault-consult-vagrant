storage "consul" {
  address = "NODE_IP:8500"
  path = "vault"
}

listener "tcp" {
  address = "NODE_IP:8200"
  tls_disable = 1
}
