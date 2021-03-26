variable "LINODE_TOKEN" {}


provider "linode" {
  #token = "$LINODE_TOKEN"
   token = "$LINODE_TOKEN"
}

resource "linode_sshkey" "localkey" {
  label = "localkey"
  ssh_key = file("~/.ssh/authorized_keys")
}

resource "linode_firewall" "cloudbast_firewall" {
  label = "cloudbast_firewall"
  #tags  = ["test"]

  inbound {
    protocol  = "TCP"
    ports     = ["80"]
    addresses = ["0.0.0.0/0"]
  }


  linodes = [linode_instance.cloudbast01.id]
}

resource "linode_instance" "cloudbast01" {
  #label      = "complex_instance"
  #group      = "foo"
  #tags = [ "test" ]
  region     = "eu-central"
  type       = "g6-nanode-1"
  private_ip = true

  #disk {
    #label = "boot"
    #size = 3000
    #image  = "linode/ubuntu18.04"

    # Any of authorized_keys, authorized_users, and root_pass
    # can be used for provisioning.
    authorized_keys = ["${linode_sshkey.localkey.ssh_key}"]
    root_pass = "terraform01"
  }

