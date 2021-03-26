# deo is digitalocean
variable "do_token" {}

# onfigure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

variable "cidr_subnet" {
  description = "CIDR block for the internal fra1 subnet"
  default = "10.2.1.0/24"
}

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

resource "digitalocean_domain" "habbispw" {
  name       = "habbis.pw"
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "cloudbas01" {
  domain = digitalocean_domain.habbispw.name
  type   = "A"
  name   = "cloudbast01"
  value = digitalocean_droplet.cloudbast01.ipv4_address
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "proxy01" {
  domain = digitalocean_domain.habbispw.name
  type   = "A"
  name   = "proxy01"
  value = digitalocean_droplet.proxy01.ipv4_address
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "db01" {
  domain = digitalocean_domain.habbispw.name
  type   = "A"
  name   = "db01"
  value = digitalocean_droplet.db01.ipv4_address
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "media01" {
  domain = digitalocean_domain.habbispw.name
  type   = "A"
  name   = "media01"
  value = digitalocean_droplet.media01.ipv4_address
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "media02" {
  domain = digitalocean_domain.habbispw.name
  type   = "A"
  name   = "media02"
  value = digitalocean_droplet.media02.ipv4_address
}

# privat network setup deo will be removed when destroyed
resource "digitalocean_vpc" "fra2-net" {
  name     = "fra2-net"
  region   = "fra1"
  ip_range = "${var.cidr_subnet}"
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
resource "digitalocean_droplet" "cloudbast01" {
  name     = "cloudbast01"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create server
resource "digitalocean_droplet" "db01" {
  name     = "db01"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create reverse proxy server
resource "digitalocean_droplet" "proxy01" {
  name     = "proxy01"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}
# create server
resource "digitalocean_droplet" "media01" {
  name     = "media01"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create server
resource "digitalocean_droplet" "media02" {
  name     = "media02"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}


# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "cloudbast" {
  name = "cloudbast-allow-out-HTTPS-HTTP-in-SSH-from-any"

  droplet_ids = [digitalocean_droplet.cloudbast01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
}

  # these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  
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

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "media" {
  name = "app-allow-out-HTTPS-HTTP-in-SSH-from-fra2"

  droplet_ids = [digitalocean_droplet.media01.id, digitalocean_droplet.media02.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}


  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["10.2.1.0/24"]
}
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["10.2.1.0/24"]
}

  
# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
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

# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "database" {
  name = "app-allow-out-HTTPS-HTTP-in-SSH-MYSQL-from-fra2"

  droplet_ids = [digitalocean_droplet.db01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}

  inbound_rule {
    protocol         = "tcp"
    port_range       = "3306"
    source_addresses = ["10.2.1.0/24"]
}

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  
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


# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "proxy" {
  name = "app-allow-out-HTTPS-HTTP-in-SSH-from-fra2-allow-in-HTTP-HTTPS"

  droplet_ids = [digitalocean_droplet.proxy01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}


  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["10.2.1.0/24"]
}

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["10.2.1.0/24"]
}

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  
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
