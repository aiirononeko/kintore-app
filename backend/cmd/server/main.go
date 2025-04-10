package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"connectrpc.com/connect"
	"golang.org/x/net/http2"     // HTTP/2 プロトコルのサポートに必要
	"golang.org/x/net/http2/h2c" // HTTP/2 Cleartext (h2c) のサポートに必要

	// 生成されたコードのパッケージをインポート
	greetv1 "github.com/aiirononeko/kintore-app/backend/gen/greet/v1"        // greet.pb.go で定義された型など
	"github.com/aiirononeko/kintore-app/backend/gen/greet/v1/greetv1connect" // greet.connect.go で定義されたハンドラなど
)

// greetServer は GreetServiceHandler インターフェースを実装する構造体
type greetServer struct{}

// Greet メソッドの実装
// context.Context はリクエストのスコープやキャンセル情報を伝搬するために使われます。
// connect.Request はリクエストヘッダーやメッセージ本体にアクセスする型です。
// connect.Response はレスポンスヘッダーやメッセージ本体を設定する型です。
func (s *greetServer) Greet(
	ctx context.Context,
	req *connect.Request[greetv1.GreetRequest],
) (*connect.Response[greetv1.GreetResponse], error) {
	log.Println("Request headers: ", req.Header()) // リクエストヘッダーをログ出力

	// レスポンスメッセージを作成
	res := connect.NewResponse(&greetv1.GreetResponse{
		// req.Msg でリクエストメッセージ本体 (*greetv1.GreetRequest) にアクセス
		Greeting: fmt.Sprintf("Hello, %s!", req.Msg.Name),
	})

	// レスポンスヘッダーを設定 (任意)
	res.Header().Set("Greet-Version", "v1")

	return res, nil // 成功時はレスポンスと nil エラーを返す
}

func main() {
	// GreetServiceHandler を実装した greetServer のインスタンスを作成
	greeter := &greetServer{}

	// 新しい HTTP ServeMux (ルーター) を作成
	mux := http.NewServeMux()

	// 生成された NewGreetServiceHandler を使って、
	// greetServer の実装を HTTP ハンドラとして mux に登録
	// パスは自動的に "/greet.v1.GreetService/" のように設定される
	path, handler := greetv1connect.NewGreetServiceHandler(greeter)
	mux.Handle(path, handler)
	log.Println("GreetService handler registered at:", path)

	// HTTP サーバーを起動
	// :8080 でリッスン
	// h2c.NewHandler は、HTTP/1.1 と HTTP/2 Cleartext (h2c) の両方をサポートするハンドラを作成
	// これにより、gRPC クライアント (通常 HTTP/2 を使用) と Web ブラウザ (通常 HTTP/1.1 または HTTP/2 over TLS) の両方から接続できる
	addr := ":8080"
	log.Println("Starting server on", addr)
	err := http.ListenAndServe(
		addr,
		h2c.NewHandler(mux, &http2.Server{}), // h2c ハンドラを使用
	)
	if err != nil {
		log.Fatalf("failed to serve: %v", err) // エラー発生時はログを出力して終了
	}
}
