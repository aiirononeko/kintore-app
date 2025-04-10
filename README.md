# Kintore App (仮)

## 概要

このアプリケーションは、筋肥大にフォーカスしたトレーニングを記録・管理するためのアプリケーションです。特に、**トレーニングボリューム**の観点から日々のトレーニングを記録し、自身の成長を可視化・管理することを目的としています。

### 開発背景と解決したい課題

開発者自身が既存の筋トレ記録アプリを利用する中で感じた以下の課題を解決するために、このプロジェクトを開始しました。

1.  **WatchOSでの記録体験:** Apple Watch単体でトレーニング中に記録できる、本格的なトレーニー向けのアプリが存在しない。既存のWatchアプリは機能が限定的であったり、ライトユーザー向けに最適化されていることが多い。
2.  **スマホアプリのUI/UX:**
    *   過去のトレーニングボリューム（部位別・種目別）を確認するために、複数回のページ遷移が必要になる場合が多い。
    *   広告表示がユーザー体験を著しく妨げている場合がある。

### 目標とする機能・体験

このアプリケーションでは、以下の実現を最終的なゴールとします。

*   **WatchOS:** シンプルかつ効率的なUIで、トレーニング中のログ記録をストレスなく行える体験。
*   **Web/スマホ:** 過去のトレーニングデータとの比較が一目でわかる、トレーニングボリュームの可視化。
*   **スマホ:** トレーニング履歴や成長を網羅的に確認できる、高機能なダッシュボード。

## 将来の展望

*   **AI連携:** 最新のトレーニング科学に関する論文等をベクトルデータベースに格納し、それを参照することで、AIがユーザーのデータに基づいた最適なトレーニングボリューム、メニュー、プログラムを提案する機能の実現を目指します。筋肥大を目指すトレーニーにとって、よりパーソナライズされた高度なトレーニングパートナーとなることを目標とします。

## 開発ロードマップ

1.  **Phase 1: Webアプリケーション開発**
    *   まずは個人利用を目的としたWebアプリケーションとして、基本的な記録機能、ボリューム計算・表示機能、ダッシュボード機能を開発します。
2.  **Phase 2: iOS / WatchOS アプリケーション開発**
    *   Web版での知見を活かし、ネイティブアプリならではの体験を提供します。特にWatchOS版では、スタンドアロンでの快適な記録操作を目指します。
3.  **Phase 3: AI機能開発**
    *   AI連携機能の開発に着手します。

## 今後の開発ステップ（案）

1.  **フロントエンドでのConnectクライアント導入:** `@connectrpc/connect-web` を利用し、型安全なAPI呼び出しを実現する。
2.  **データモデル定義 (.proto):** トレーニング記録に必要なデータ構造（ユーザー、トレーニングセッション、種目、セット、レップ、重量など）を Protocol Buffers で定義する。
3.  **バックエンドAPI拡張:** 定義したデータモデルに基づき、CRUD操作（作成、読み取り、更新、削除）のためのAPIメソッドを `.proto` に追加し、バックエンドで実装する (`connect-go`)。
4.  **データベース選定と実装:** バックエンドで使用するデータベース（例: PostgreSQL, Firestore）を決定し、API実装と連携させる。マイグレーションツールなども検討。
5.  **フロントエンドUI構築:** トレーニング記録の入力フォーム、記録一覧、ボリューム表示などのUIコンポーネントをReactで作成する。
6.  **認証:** ユーザー登録・ログイン機能を追加する (例: Firebase Authentication, Auth0 など)。
7.  **テスト:** バックエンド・フロントエンドの単体テスト、結合テストを整備する。
8.  **CI/CD:** GitHub Actions などを用いて、テストとデプロイの自動化パイプラインを構築する。

## 技術スタック（確定）

*   **Monorepo Tool:** Nx (`^20.7.2`)
*   **Backend:**
    *   Language: Golang (`go 1.24.0` 時点)
    *   API Framework: Connect RPC (`connectrpc.com/connect` v1.x 系)
    *   Deployment: Cloud Run (予定)
    *   Proto Generation: `protoc`, `protoc-gen-go`, `protoc-gen-connect-go`
*   **Web Frontend:**
    *   Framework: React (`^19.0.0`), React Router (`^7.5.0`) (SSR on Cloudflare)
    *   Build Tool: Vite (`^6.2.1`)
    *   Deployment: Cloudflare Pages/Workers
    *   Styling: Tailwind CSS (`^4.0.0`)
    *   Package Manager: bun (`^1.2.9` 時点)
    *   Linter/Formatter: Biome
    *   API Client: Connect RPC (`@connectrpc/connect`, `@connectrpc/connect-web` v1.x 系)
    *   Proto Runtime: `@bufbuild/protobuf` (v1.x 系)
    *   Proto Generation: `buf` CLI (`@bufbuild/buf`), `@bufbuild/protoc-gen-es`, `@connectrpc/protoc-gen-connect-es` (v1.x 系)
*   **Database:** 検討中 (Goとの相性が良く、低コストなものを想定)
*   **iOS / WatchOS:** Swift, SwiftUI (予定)

## アーキテクチャ方針

将来的なマルチプラットフォーム展開（Web, iOS, WatchOS）とAI機能の統合をスムーズに行うため、初期段階から以下を考慮した設計・技術選定を行います。

*   **Backend:**
    *   ドメイン駆動設計 (DDD) とレイヤードアーキテクチャを採用し、ビジネスロジックの関心を分離します。
    *   各レイヤーは単一方向に依存し、テスト容易性、保守性、拡張性を高めます。
    *   プラットフォーム共通のAPI (Connect RPC) を提供します。
*   **Frontend (Web):**
    *   React Router V7.4系の`loader` / `action` を活用し、データ取得や更新処理をサーバー（またはエッジ）寄りに配置します。
    *   フロントエンドはUIロジックに集中し、状態管理をシンプルに保ち、パフォーマンスを最適化します。
*   **コード共通化:** 可能な範囲で型定義やユーティリティ関数などを共通化し、プラットフォーム間の差異を吸収する設計を目指します (例: `shared` ディレクトリの活用)。
*   **ディレクトリ構成:**
    *   プロジェクトルート直下に `backend`, `web`, (`mobile`) ディレクトリを配置するモノリポ構成。
    *   Protocol Buffers定義は `backend/proto` に配置。
    *   生成コード:
        *   Backend Go: `backend/gen`
        *   Frontend TS: `web/app/gen`
    *   共通コードは `packages` や `shared` ディレクトリに配置することを検討 (未実装)。

## インフラストラクチャ (IaC)

*   **ツール:** Terraform を使用し、Cloud Run, Cloudflare Workers, データベースなどのインフラリソースをコードで管理します。
*   **状態管理:** Terraform Cloud や GCS Backend などを使用して Terraform の状態ファイル (tfstate) を安全に管理します。(要検討)

## CI/CD

*   **プラットフォーム:** GitHub Actions を使用します。
*   **CI (継続的インテグレーション):**
    *   トリガー: プルリクエスト時
    *   ジョブ:
        *   Backend Lint (Go): `./nx lint backend` を実行します。
        *   Frontend Lint (TS/React): `./nx lint web` を実行します。
*   **CD (継続的デプロイ):**
    *   トリガー: `main` ブランチへのプッシュ時 (CI成功後)
    *   ジョブ:
        *   Deploy Backend: Dockerイメージをビルドし、Artifact Registry (または GCR) へプッシュ後、Cloud Run へデプロイします。Google Cloud への認証には Workload Identity Federation を使用します。
        *   Deploy Frontend: アプリケーションをビルドし、Cloudflare Workers/Pages へデプロイします。`wrangler` コマンド (Cloudflare Action) を使用します。

## セットアップと開発

### 必要なツール

*   Go (`1.21` 以上推奨)
*   Protocol Buffer Compiler (`protoc`) - (例: `brew install protobuf`)
*   `protoc-gen-go`, `protoc-gen-connect-go` (Go プラグイン) - (例: `go install google.golang.org/protobuf/cmd/protoc-gen-go@latest connectrpc.com/connect/cmd/protoc-gen-connect-go@latest`)
*   Node.js (v20 以上推奨)
*   bun (`curl -fsSL https://bun.sh/install | bash`)
*   Nx (`./nx` コマンドを使用。依存関係はルート `package.json` を参照)
*   (Frontend) `buf` CLI (`bun add -d @bufbuild/buf`) - (web ディレクトリ内)
*   (Frontend) Biome (`bun add -d --exact @biomejs/biome`) - (web ディレクトリ内)

### 依存関係のインストール

プロジェクトルートで以下を実行します。

```bash
bun install
# (初回のみ、または backend/go.mod が変更された場合)
cd backend && go mod tidy && cd ..
```

### 主な開発コマンド (プロジェクトルートから実行)

Nx を使用して、各プロジェクトのタスクを実行します。

*   **Web フロントエンド:**
    *   ビルド: `./nx build web`
    *   開発サーバー起動: `./nx serve web`
    *   Lint: `./nx lint web`
    *   Format: `./nx format web`
*   **Backend (Go):**
    *   ビルド: `./nx build backend` (成果物は `./dist/backend_server`)
    *   開発サーバー起動: `./nx serve backend`
    *   テスト: `./nx test backend`
    *   Lint: `./nx lint backend`
*   **全プロジェクト:**
    *   ビルド: `bun run build:all` (または `./nx run-many --target=build`)
    *   Lint: `bun run lint:all` (または `./nx run-many --target=lint`)

### スキーマ変更時のワークフロー

1.  `backend/proto/**/*.proto` ファイルを編集。
2.  Backend コード生成: `backend` ディレクトリで `protoc ...` (または `go generate`)。
3.  Frontend コード生成: `web` ディレクトリで `bunx buf generate ../backend/proto`。
4.  必要に応じてプロジェクトルートで `bun install` や `backend` ディレクトリで `go mod tidy` を実行。
5.  各サーバー/クライアントのコードを修正。 