
# esxi sever
variable "esxi_server" {
  type = string 
  default = ""

}

# esxi user
variable "vsphere_user" {
  type = string
  default = "root"
}

# esxi password
variable "vsphere_password" {
  type = string
  default = ""

}

# vcenter password
variable "vsphere_password" {
  type = string
  default = "yourpass"

}

# vcenter sever
variable "vsphere_server" {
  type = string 
  default = "vcenterip"

}

# vcenter user
variable "vsphere_user" {
  type = string
  default = "youruser"
}

# vcenter password
variable "vsphere_password" {
  type = string
  default = "yourpass"

}

# cluster name
variable "cluster" {
  type = string
  default = "cluster01"

}


# datastore name
variable "datastore" {
  type = string
  default = "vmstore01"

}

# network adapter
variable "network" {
  type = string
  default = "test"

}

# hostname and vmname
variable "vmname" {
  type = string 
  default = ""

}
