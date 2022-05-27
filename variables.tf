variable "cf_email" {
  type = string
  description = "Cloudflare account email"
}

variable "cf_api_key" {
  type = string
  description = "Cloudflare API key"
  sensitive = true
}

variable "cf_account_id" {
  type = string
  description = "Cloudflare account ID"
}

variable "cf_workers_subdomain" {
  type = string
  description = "Cloudflare workers subdomain"
}

variable "connection_name" {
  type = string
  description = "social connection name"
  default = "cf-log"
}

variable "token_endpoint" {
  type = string
  description = "upstream idp token endpoint"
}

variable "authorization_endpoint" {
  type = string
  description = "upstream idp authorization endpoint"
}

variable "upstream_client_id" {
  type = string
  description = "upstream idp client_id"
}

variable "upstream_client_secret" {
  type = string
  description = "upstream idp client_secret"
  sensitive = true
}

variable "scopes" {
  type = list(string)
  description = "upstream idp scopes"
  default = ["openid"]
}


variable "auth0_domain" {
  type = string
  description = "auth0 domain"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret"
  sensitive = true
}
