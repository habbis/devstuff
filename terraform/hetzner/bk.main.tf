
# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}


data "hcloud_ssh_key" "ssh_key_1" {
  name = "latitude7490"
}
data "hcloud_ssh_key" "ssh_key_2" {
  name = "ebbestad_linbast"
}
data "hcloud_ssh_key" "ssh_key_3" {
  name = "yubikey_rundthalsen3"
}
data "hcloud_ssh_key" "ssh_key_4" {
  name = "yubikey_laptop3"
}
data "hcloud_ssh_key" "ssh_key_5" {
  name = "ryzen5"
}

# ansible example
# find all images with api
# curl -H "Authorization: Bearer $API_TOKEN" 'https://api.hetzner.cloud/v1/images/'

# server images 
data "hcloud_image" "centos8_lite" {
  id = "25979598"
}
#data "hcloud_image" "centos8_postgres12" {
#  id = "25979588"
#}
#data "hcloud_image" "centos8_docker" {
#  id = "25979599"
#}

# network
resource "hcloud_network" "mynet" {
  name = "my-net"
  ip_range = "10.2.1.0/24"
}
resource "hcloud_network_subnet" "office" {
  network_id = hcloud_network.mynet.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "10.2.1.0/24"
}

# gateway and reverse proxy 
resource "hcloud_server" "proxy" {
  name = "proxy"
  image = data.hcloud_image.centos8_lite.name
  location = "hel1"
  ssh_keys  = [data.hcloud_ssh_key.ssh_key_1.id,data.hcloud_ssh_key.ssh_key_2.id,data.hcloud_ssh_key.ssh_key_3.id,data.hcloud_ssh_key.ssh_key_4.id,data.hcloud_ssh_key.ssh_key_5.id]
  server_type = "cx11"
}
