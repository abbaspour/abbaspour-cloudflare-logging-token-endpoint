resource "cloudflare_worker_script" "cname_worker_script" {
  name = "token-endpoint"
  content = file("worker.js")
  plain_text_binding {
    name = "ENDPOINT"
    text = var.main_endpoint
  }
}
