variable "gcp_project_id" {
  description = "Google Cloud Project ID"
  type        = string
  # default = "your-gcp-project-id" # デフォルト値を設定するか、実行時に指定
}

variable "gcp_region" {
  description = "Google Cloud Region"
  type        = string
  default     = "asia-northeast1" # 例: 東京リージョン
}

variable "artifact_registry_repo_id" {
  description = "Artifact Registry Repository ID for backend Docker images"
  type        = string
  # default = "kintore-app-backend-repo"
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name for the backend"
  type        = string
  # default = "kintore-app-backend"
}

variable "db_instance_name" {
  description = "Cloud SQL database instance name"
  type        = string
  # default = "kintore-app-db-instance"
}

variable "db_name" {
  description = "Cloud SQL database name"
  type        = string
  # default = "kintore_app"
}

variable "db_user_name" {
  description = "Cloud SQL database user name"
  type        = string
  # default = "kintore_app_user"
}

# variable "db_user_password" {
#   description = "Cloud SQL database user password (use Secrets Manager)"
#   type        = string
#   sensitive   = true
# }

# Cloudflare の認証情報は環境変数での設定を推奨するため、
# ここでの変数は必須ではないが、必要に応じて定義
# variable "cloudflare_api_token" {
#   description = "Cloudflare API Token"
#   type        = string
#   sensitive   = true
# }
#
# variable "cloudflare_account_id" {
#   description = "Cloudflare Account ID"
#   type        = string
# }
