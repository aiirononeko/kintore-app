terraform {
  required_version = ">= 1.0" # 必要に応じてバージョン制約を調整

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0" # 必要に応じてバージョン制約を調整
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.0" # 必要に応じてバージョン制約を調整
    }
  }

  # Terraform State Backend の設定 (例: GCS)
  # backend "gcs" {
  #   bucket  = "your-tfstate-bucket-name" # 事前に作成したGCSバケット名
  #   prefix  = "kintore-app/terraform.tfstate"
  # }
}
