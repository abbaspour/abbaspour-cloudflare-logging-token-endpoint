terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email   = var.cf_email
  api_key = var.cf_api_key
  account_id = var.cf_account_id
}


