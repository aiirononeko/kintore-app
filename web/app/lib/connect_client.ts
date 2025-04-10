import { createConnectTransport } from "@connectrpc/connect-web";
import { createClient } from "@connectrpc/connect";

// バックエンドサーバーのベースURL
// 環境変数などから取得するのが望ましいが、一旦ハードコード
const baseUrl = "http://localhost:8080";

// Connect トランスポートを作成
// createConnectTransport は Connect プロトコルを使用
// gRPC-Web を使いたい場合は createGrpcWebTransport を使用
const transport = createConnectTransport({
  baseUrl: baseUrl,
  // Workers 環境での fetch の redirect オプション問題を回避
  fetch: (input, init) => {
    // init?.redirect の値に関わらず、常に 'manual' を設定する
    return fetch(input, { ...init, redirect: 'manual' });
  },
});

// GreetService のクライアントを作成
// import { GreetService } from "../gen/greet/v1/greet_connect"; // 絶対パスまたは適切な相対パスに修正必要
import { GreetService } from "../gen/greet/v1/greet_connect"; // 相対パスに変更

export const greetClient = createClient(GreetService, transport);
