# ここに Cloud Run, Cloudflare Workers, Database などのリソース定義を記述します。 

# --- GCP Backend Resources ---

# Artifact Registry Repository (Docker Images)
resource "google_artifact_registry_repository" "backend_repo" {
  provider      = google
  location      = var.gcp_region
  repository_id = var.artifact_registry_repo_id # 例: "kintore-app-backend-repo"
  description   = "Docker repository for kintore-app backend"
  format        = "DOCKER"
}

# Cloud Run Service (Backend Application)
resource "google_cloud_run_v2_service" "backend_service" {
  provider = google
  name     = var.cloud_run_service_name # 例: "kintore-app-backend"
  location = var.gcp_region

  # --- アクセス制御 --- #
  # ingress = "INGRESS_TRAFFIC_ALL" # 一旦すべてのトラフィックを許可
  # TODO: 本番環境ではアクセスを制限する。
  # 方法1: Cloud Armor で Cloudflare の Egress IP のみを許可する (IP範囲は変動可能性あり: https://www.cloudflare.com/ips/)
  # 方法2: IAP を有効にし、Cloudflare Workers から認証情報を付与する
  # 方法3: VPC Connector + Internal Load Balancer (より複雑)

  template {
    containers {
      image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${google_artifact_registry_repository.backend_repo.repository_id}/${var.cloud_run_service_name}:latest"
      ports {
        container_port = 8080 # Dockerfile で EXPOSE したポート
      }
      # 必要に応じてリソース制限や環境変数を設定
      # resources {
      #   limits = {
      #     cpu    = "1000m"
      #     memory = "512Mi"
      #   }
      # }
      # env {
      #   name  = "DATABASE_URL"
      #   value = "..."
      # }
    }
    # 必要に応じてスケーリング設定などを追加
    # scaling {
    #   min_instance_count = 0
    #   max_instance_count = 1
    # }
  }

  # デプロイ時に新しいリビジョンにトラフィックを100%移行
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  # Cloud Run 起動用サービスアカウント (必要に応じて設定)
  # service_account = "..."
}

# --- GCP Database Resources (PostgreSQL - Cloud SQL) ---
# TODO: データベースの選択肢を再検討。
# Cloud SQL はフルマネージドだがサーバーレスではない。
# サーバーレスオプション: Cloud SQL (beta?), AlloyDB Omni (beta?), Turso, Neon (外部サービス、レイテンシ要確認)

resource "google_sql_database_instance" "db_instance" {
  provider            = google
  name                = var.db_instance_name # 例: "kintore-app-db-instance"
  database_version    = "POSTGRES_15"      # 使用するバージョンを指定
  region              = var.gcp_region

  settings {
    tier = "db-f1-micro" # 開発用。本番では適切なサイズに変更
    # availability_type = "REGIONAL" # 高可用性が必要な場合
    ip_configuration {
      ipv4_enabled    = true # Public IP を有効にするか
      # private_network = "projects/${var.gcp_project_id}/global/networks/default" # VPC Peering を設定して Private IP 接続を推奨
      # authorized_networks {
      #   name  = "allow-all-temp" # 本番では制限すること
      #   value = "0.0.0.0/0"
      # }
    }
    backup_configuration {
      enabled = true
    }
  }

  # 削除保護 (本番では有効推奨)
  # deletion_protection = true
}

resource "google_sql_database" "app_db" {
  provider = google
  instance = google_sql_database_instance.db_instance.name
  name     = var.db_name # 例: "kintore_app"
}

resource "google_sql_user" "app_user" {
  provider = google
  instance = google_sql_database_instance.db_instance.name
  name     = var.db_user_name # 例: "kintore_app_user"

  # パスワードは Secrets Manager などで管理し、参照することを強く推奨
  # password = var.db_user_password
  # password_policy {
  #   enable_failed_attempts_check = true
  #   enable_password_verification = true
  # }

  # TODO: random_password リソースを使って初期パスワードを設定し、Secrets Manager に登録するフローを検討
}

# --- Cloudflare Resources (Frontend) ---
# Cloudflare Workers の設定は wrangler.toml で管理するため、
# Terraform で明示的に管理するリソースは少ないかもしれない。
# カスタムドメイン、KV Namespace、Durable Objects などが必要な場合はここに追加。

# 例: KV Namespace
# resource "cloudflare_kv_namespace" "example_kv" {
#   title = "example-kv-namespace"
# }

# wrangler.toml で上記 KV Namespace を参照するには、terraform output で ID を出力し、
# それを wrangler.toml に手動または CI/CD で埋め込む必要がある。

# --- Outputs (必要な場合) ---
# output "cloud_run_service_url" {
#   value = google_cloud_run_v2_service.backend_service.uri
# }
# output "db_instance_connection_name" {
#   value = google_sql_database_instance.db_instance.connection_name
# } 