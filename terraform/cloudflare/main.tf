# Configure the Cloudflare provider.
# You may optionally use version directive to prevent breaking changes occurring unannounced.
provider "cloudflare" {
  version = "~> 2.0"
  email   = "${var.cloudflare_email}"
  api_key = "${var.cloudflare_api_key}"
}

# Add a record to the domain
resource "cloudflare_record" "foobar" {
  zone_id = var.cloudflare_zone_id
  name    = "terraform"
  value   = "placeholder"
  type    = "A"
  ttl     = 3600
}
