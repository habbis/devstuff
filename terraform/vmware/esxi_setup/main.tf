 provider "vsphere" {
  user           = var.esxi_user
  password       = var.esxi_password
  vsphere_server = var.esxi_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}



data "vsphere_host" "esxi_host" {
  name          = "ironfist"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_host_virtual_switch" "switch" {
  name           = "vSwitchTerraformTest"
  host_system_id = "${data.vsphere_host.esxi_host.id}"

  network_adapters = ["vmnic0", "vmnic1"]

  active_nics  = ["vmnic0"]
  standby_nics = ["vmnic1"]
}