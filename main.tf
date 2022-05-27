locals {
  worker_name = "${var.connection_name}-token-endpoint"
  cf_token_endpoint = "https://${cloudflare_worker_script.cname_worker_script.name}.${var.cf_workers_subdomain}/token"
  jwt_io_url_encoded= urlencode("https://jwt.io")
}

resource "cloudflare_worker_script" "cname_worker_script" {
  name = local.worker_name
  content = file("worker.js")
  plain_text_binding {
    name = "ENDPOINT"
    text = var.token_endpoint
  }
}

data "local_file" "fetchUserProfile" {
  filename = "./fetchUserProfile.js"
}

resource "auth0_connection" "cf-logging" {
  name = var.connection_name
  strategy = "oauth2"
  options {
    client_id = var.upstream_client_id
    client_secret = var.upstream_client_secret
    authorization_endpoint = var.authorization_endpoint
    token_endpoint = local.cf_token_endpoint
    scopes = var.scopes
    scripts = {
      fetchUserProfile = data.local_file.fetchUserProfile.content
    }
  }

  enabled_clients = [
    auth0_client.test_client.client_id
  ]
}


resource "auth0_client" "test_client" {
  name = "${var.connection_name}-test-client"
  description = "${var.connection_name} Custom Social Connection Test Client"
  app_type = "spa"
  oidc_conformant = true
  is_first_party = true

  callbacks = [
    "https://jwt.io"
  ]

  jwt_configuration {
    alg = "RS256"
  }
}

output "authorization_url" {
  value = "https://${var.auth0_domain}/authorize?client_id=${auth0_client.test_client.client_id}&connection=${auth0_connection.cf-logging.name}&response_type=id_token&redirect_uri=${local.jwt_io_url_encoded}&nonce=n1&state=s1"
}


