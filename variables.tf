variable "cf_email" {
  type = string
  description = "Cloudflare account email"
}

variable "cf_api_key" {
  type = string
  description = "Cloudflare API key"
  sensitive = true
}

/*
variable "cf_account_id" {
  type = string
  description = "Cloudflare account ID"
}
*/

variable "main_endpoint" {
  type = string
  description = "main token endpoint"
}
