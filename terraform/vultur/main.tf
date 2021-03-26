variable "VULTR_API_KEY" {}

# Configure the Vultr Provider
provider "vultr" {
  api_key = "VULTR_API_KEY"

  rate_limit = 700
  retry_limit = 10
}

# to list your ssh key related to your vultur account user the api
# curl -H 'API-Key: yourkey' https://api.vultr.com/v1/sshkey/list

variable "ssh_keys01" {
    description = "ssh key id from account"
    default = "5bf98edbf3736"
  }


# to list your ssh key related to your vultur account
variable "ssh_keys02" {
    description = "ssh key id from account"
    default = "5bf98eed3df01"
  }


# to list your ssh key related to your vultur account
variable "ssh_keys03" {
    description = "ssh key id from account"
    default = "5de9509452f85"
  }


# to list your ssh key related to your vultur account
variable "ssh_keys04" {
    description = "ssh key id from account"
    default = "5de95543deae3"
  }


# to list your ssh key related to your vultur account
variable "ssh_keys05" {
    description = "ssh key id from account"
    default = "5eb8620dcec67"
  }

resource "vultr_network" "fra02-net" {
    description = "privat network frankfurt"
    region_id = 9
    cidr_block  = "10.2.1.0/28"
}


resource "vultr_server" "cloudbast01" {
    plan_id = "201"
    region_id = "9"
    os_id = "167"
    label = "cloudbast"
    tag = "cloudbast"
    hostname = "cloudbast01"
    network_ids = ["${vultr_network.fra02-net.id}"]
    ssh_key_ids = ["${var.ssh_keys01}","${var.ssh_keys02}", "${var.ssh_keys03}", "${var.ssh_keys04}", "${var.ssh_keys05}" ]
    firewall_group_id = vultr_firewall_group.cloudbast.id
}


resource "vultr_server" "proxy01" {
    plan_id = "201"
    region_id = "9"
    os_id = "167"
    label = "proxy"
    tag = "proxy"
    hostname = "proxy01"
    network_ids = ["${vultr_network.fra02-net.id}"]
    ssh_key_ids = ["${var.ssh_keys01}","${var.ssh_keys02}", "${var.ssh_keys03}", "${var.ssh_keys04}", "${var.ssh_keys05}" ]
    firewall_group_id = vultr_firewall_group.proxy.id
}


resource "vultr_server" "db01" {
    plan_id = "201"
    region_id = "9"
    os_id = "167"
    label = "db"
    tag = "db01"
    hostname = "db01"
    network_ids = ["${vultr_network.fra02-net.id}"]
    ssh_key_ids = ["${var.ssh_keys01}","${var.ssh_keys02}", "${var.ssh_keys03}", "${var.ssh_keys04}", "${var.ssh_keys05}" ]
    firewall_group_id = vultr_firewall_group.db.id
}

resource "vultr_server" "media01" {
    plan_id = "201"
    region_id = "9"
    os_id = "167"
    label = "media"
    tag = "media"
    hostname = "media01"
    network_ids = ["${vultr_network.fra02-net.id}"]
    ssh_key_ids = ["${var.ssh_keys01}","${var.ssh_keys02}", "${var.ssh_keys03}", "${var.ssh_keys04}", "${var.ssh_keys05}" ]
    firewall_group_id = vultr_firewall_group.media.id
}


resource "vultr_server" "media02" {
    plan_id = "201"
    region_id = "9"
    os_id = "167"
    label = "media"
    tag = "media"
    hostname = "media02"
    network_ids = ["${vultr_network.fra02-net.id}"]
    ssh_key_ids = ["${var.ssh_keys01}","${var.ssh_keys02}", "${var.ssh_keys03}", "${var.ssh_keys04}", "${var.ssh_keys05}" ]
    firewall_group_id = vultr_firewall_group.media.id
}

resource "vultr_firewall_group" "cloudbast" {
    description = "firewall for cloudbast"
}

resource "vultr_firewall_rule" "cloudbast-ssh" {
    #firewall_group_id = ["${vultr_firewall_group.cloudbast.id}"]
    firewall_group_id = vultr_firewall_group.cloudbast.id
    protocol = "tcp"
    network = "0.0.0.0/0"
    from_port = "22"
    #to_port = "8090"
}


resource "vultr_firewall_group" "proxy" {
    description = "firewall for reverse proxy"
}

resource "vultr_firewall_rule" "proxy_ssh" {
    firewall_group_id = vultr_firewall_group.proxy.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "22"
    #to_port = "8090"
}


resource "vultr_firewall_rule" "proxy_http" {
    firewall_group_id = vultr_firewall_group.proxy.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "80"
    #to_port = "80"
}


resource "vultr_firewall_rule" "proxy_https" {
    firewall_group_id = vultr_firewall_group.proxy.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "443"
    #to_port = "443"
}

resource "vultr_firewall_group" "db" {
    description = "firewall for database servers"
}

resource "vultr_firewall_rule" "db_ssh" {
    firewall_group_id = vultr_firewall_group.db.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "22"
    #to_port = "8090"
}


resource "vultr_firewall_rule" "db_mysql" {
    firewall_group_id = vultr_firewall_group.db.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "3306"
    #to_port = "80"
}


resource "vultr_firewall_group" "media" {
    description = "firewall for media servers"
}


resource "vultr_firewall_rule" "media_ssh" {
    firewall_group_id = vultr_firewall_group.media.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "22"
    #to_port = "8090"
}


resource "vultr_firewall_rule" "media_port_range_tcp" {
    firewall_group_id = vultr_firewall_group.media.id
    protocol = "tcp"
    network = "10.2.1.0/28"
    from_port = "80"
    to_port = "8443"
}


resource "vultr_firewall_rule" "media_port_range_udp" {
    firewall_group_id = vultr_firewall_group.media.id
    protocol = "udp"
    network = "10.2.1.0/28"
    from_port = "80"
    to_port = "8443"
}

