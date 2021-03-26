terraform {
  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "0.18.0-beta.1"
    }
  }
}

provider "unifi" {
  username = "youruser" # optionally use UNIFI_USERNAME env var
  password = "yourpass" # optionally use UNIFI_PASSWORD env var
  api_url  = "https://yourunify:8443/api/login"

# optionally use UNIFI_API env var

  # you may need to allow insecure TLS communications unless you have configured
  # certificates for your controller
  allow_insecure = true
  # var.insecure # optionally use UNIFI_INSECURE env var

  # if you are not configuring the default site, you can change the site
  # site = "foo" or optionally use UNIFI_SITE env var
}

resource "unifi_network" "vlan" {
  name    = "test03"
  purpose = "vlan-only"
  vlan_id      = 100
}

