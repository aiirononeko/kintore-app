# --- ビルドステージ ---
FROM golang:1.21-alpine AS builder

# ワーキングディレクトリの設定
WORKDIR /app

# Goモジュールの依存関係を先にコピーしてキャッシュを活用
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# アプリケーションコードをコピー
# モノリポ構成のため、必要なコードのみコピーするように調整が必要な場合がある
# ここでは backend ディレクトリ全体をコピーする想定
COPY backend/ .

# アプリケーションをビルド
# CGO_ENABLED=0 で静的リンク、-ldflags="-s -w" でデバッグ情報を削除しサイズ削減
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /server ./cmd/server/main.go

# --- 実行ステージ ---
FROM alpine:latest

# ca-certificates をインストール (HTTPS通信などに必要)
RUN apk --no-cache add ca-certificates

# ビルドステージから実行可能ファイルをコピー
COPY --from=builder /server /server

# (オプション) non-root ユーザーで実行する場合
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser

# ポートを開放 (バックエンドサーバーがリッスンするポート)
EXPOSE 8080

# コンテナ起動時にサーバーを実行
ENTRYPOINT ["/server"]
