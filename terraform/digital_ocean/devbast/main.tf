# deo is digitalocean
variable "do_token" {}

# onfigure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

#variable "cidr_subnet" {
  #description = "CIDR block for the internal fra1 subnet"
  #default = "10.2.1.0/24"
#}

# my ssh keys in my digital ocean account change when using 
# own account
data "digitalocean_ssh_key" "ssh_keys01" {
  name = "latitude7490"
}


data "digitalocean_ssh_key" "ssh_keys02" {
  name = "ebbestad_linbast"
}


data "digitalocean_ssh_key" "ssh_keys03" {
  name = "yubikey_rundthalsen3"
}


data "digitalocean_ssh_key" "ssh_keys04" {
  name = "yubikey_laptop3"
}


data "digitalocean_ssh_key" "ssh_keys05" {
  name = "ryzen5"
}

# This creates a new domain if destroy will delete domain from deo account
resource "digitalocean_domain" "habbestadtech" {
  name       = "habbestad.tech"
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "devbast01" {
  domain = digitalocean_domain.habbestadtech.name
  type   = "A"
  name   = "devbast01"
  value = digitalocean_droplet.devbast01.ipv4_address
}

# privat network setup deo will be removed when destroyed
data"digitalocean_vpc" "fra1-net" {
  name     = "fra1-net"
}

# create volume for storage
#data "digitalocean_volume" "media-stor" {
  #name   = "media-stor"
  #region = "fra1"
#}

# example of attach volume to server
#resource "digitalocean_volume_attachment" "media-stor" {
  #droplet_id = digitalocean_droplet.media01.id
  #volume_id  = data.digitalocean_volume.media-stor.id
#}

# create server
resource "digitalocean_droplet" "devbast01" {
  name     = "devbast01"
  size     = "s-1vcpu-1gb"
  #image    = "ubuntu-18-04-x64"
  image    = "centos-8-x64"
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = data.digitalocean_vpc.fra1-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "devbast" {
  name = "cloudbast-allow-out-HTTPS-HTTP-in-SSH-from-any"

  droplet_ids = [digitalocean_droplet.devbast01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
}

  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["0.0.0.0/0"]
  }
}
