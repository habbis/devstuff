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


# snap shot build by packer centos_lite
data "digitalocean_image" "centos8_lite" {
  name = "centos8_lite"
}


## snap shot build by packer
data "digitalocean_image" "centos8_cloudbast" {
  name = "centos8_cloudbast"
}


# snap shot build by packer
#data "digitalocean_image" "ubuntu18_04lite" {
#  name = "ubuntu18_04lite"
#}


# snap shot build by packer
data "digitalocean_image" "centos8_docker" {
  name = "centos8_docker"
}


# snap shot build by packer
data "digitalocean_image" "centos8_postgres12" {
  name = "centos8_postgres"
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
  #droplet_id = digitalocean_droplet.repo01.id
  #volume_id  = data.digitalocean_volume.media-stor.id
#}

# create server
resource "digitalocean_droplet" "cloudbast01" {
  name     = "cloudbast01"
  size     = "s-1vcpu-1gb"
  image    = data.digitalocean_image.centos8_cloudbast.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create server
resource "digitalocean_droplet" "db01" {
  name     = "db01"
  size     = "s-1vcpu-1gb"
  image    = data.digitalocean_image.centos8_postgres12.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create reverse proxy server
resource "digitalocean_droplet" "proxy01" {
  name     = "proxy01"
  size     = "s-1vcpu-1gb"
  image    = data.digitalocean_image.centos8_lite.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}
# create server
resource "digitalocean_droplet" "repo01" {
  name     = "repo01"
  size     = "s-1vcpu-1gb"
  image    =  data.digitalocean_image.centos8_lite.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}


# create server
resource "digitalocean_droplet" "jira" {
  name     = "jira"
  size     = "s-1vcpu-1gb"
  image    =  data.digitalocean_image.centos8_lite.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create server
resource "digitalocean_droplet" "int" {
  name     = "int"
  size     = "s-1vcpu-1gb"
  image    =  data.digitalocean_image.centos8_lite.image
  region   = "fra1"
  monitoring = "true"
  vpc_uuid = digitalocean_vpc.fra2-net.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys01.id, data.digitalocean_ssh_key.ssh_keys02.id, data.digitalocean_ssh_key.ssh_keys03.id, data.digitalocean_ssh_key.ssh_keys04.id, data.digitalocean_ssh_key.ssh_keys05.id ]
  #ip_address = digitalocean_droplet.test01.ipv4_address

}

# create server
resource "digitalocean_droplet" "app" {
  name     = "app"
  size     = "s-1vcpu-1gb"
  image    = data.digitalocean_image.centos8_docker.image
  region   = "fra1"
  monitoring = "true"
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
    source_addresses = ["10.1.0.0/24"]
}

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}

  # these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "1195"
    destination_addresses = ["0.0.0.0/0"]
  }
}

# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "proxy" {
  name = "proxy-out-HTTPS-HTTP-in-SSH-from-fra2"

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

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "app" {
  name = "app-out-HTTPS-HTTP-in-SSH-from-fra2"

  droplet_ids = [digitalocean_droplet.app.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}

  inbound_rule {
    protocol         = "tcp"
    port_range       = "300-1000"
    source_addresses = ["10.2.1.0/24"]
}
  inbound_rule {
   protocol         = "udp"
    port_range       = "300-1000"
    source_addresses = ["10.2.1.0/24"]
}

  
# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }
}

# firewall rules with more than one droplet defined
resource "digitalocean_firewall" "database" {
  name = "db-allow-out-HTTPS-HTTP-in-SSH-from-fra2"

  droplet_ids = [digitalocean_droplet.db01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = ["10.2.1.0/24"]
}

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }
}



resource "digitalocean_firewall" "repo01" {
  name = "repo-allow-out-HTTPS-HTTP-SSH-repo01-from-fra2"

  droplet_ids = [digitalocean_droplet.repo01.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
}


  inbound_rule {
    protocol         = "tcp"
    port_range       = "7990"
    source_addresses = ["10.2.1.0/24"]
}


  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = ["10.2.1.0/24"]
}

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }

}

resource "digitalocean_firewall" "int" {
  name = "int-out-HTTPS-HTTP-in-SSH-wiki-fra2"

  droplet_ids = [digitalocean_droplet.int.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
  }


  inbound_rule {
    protocol         = "tcp"
    port_range       = "8090"
    source_addresses = ["10.2.1.0/24"]
  }



  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = ["10.2.1.0/24"]
  }


# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }


  outbound_rule {
    protocol         = "tcp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }
}
resource "digitalocean_firewall" "jira" {
  name = "jira-app-allow-out-HTTPS-HTTP-SMTP-DNS-in-SSH-jira-from-fra2"

  droplet_ids = [digitalocean_droplet.jira.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.2.1.0/24"]
  }


  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["10.2.1.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = ["10.2.1.0/24"]
  }

# these rules for allowing incoming traffic to sever
# when initiated by the serve.
# maye the proxy server can be made to cache update instead.
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["10.2.1.0/24"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["10.2.1.0/24"]
  }


  outbound_rule {
    protocol         = "tcp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "25"
    destination_addresses = ["10.2.1.0/24"]
  }
}


