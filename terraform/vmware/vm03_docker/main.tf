
# vcenter sever
variable "vsphere_server" {
  default = "vcenterip"

}

# vcenter user
variable "vsphere_user" {
  default = "youruser"
}

# vcenter password
variable "vsphere_password" {
  default = "yourpass"

}

# network adapter
variable "networkvlan" {
  default = "test"

}

# hostname and vmname
variable "vmname" {
  default = "hf-tdocker01"

}


provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "yourdatacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "vmstor01_darkstar"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.networkvlan
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "c7_test_template_lite"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vmname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  #folder  = vm
  num_cpus = 1
  memory   = 4024
  guest_id = "centos7_64Guest"
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = 25
}

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vmname
        domain    = "habbestad.org"
      }


      network_interface {
        ipv4_address = "10.3.1.10"
        ipv4_netmask = 24
        #dns_server_list = "10.3.1.1"
      }

      ipv4_gateway = "10.3.1.1"
      }
     }
   }
