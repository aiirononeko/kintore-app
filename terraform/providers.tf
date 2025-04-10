provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  # credentials = file("path/to/your/keyfile.json") # サービスアカウントキーを使う場合 (非推奨、Workload Identity推奨)
}

provider "cloudflare" {
  # api_token = var.cloudflare_api_token # 環境変数 CLOUDFLARE_API_TOKEN で設定推奨
  # account_id = var.cloudflare_account_id # 環境変数 CLOUDFLARE_ACCOUNT_ID で設定推奨
}
