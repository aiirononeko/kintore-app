// import { json } from "react-router"; // 削除
// import { useLoaderData } from "react-router-dom"; // 削除

import { greetClient } from "../lib/connect_client"; // greetClient をインポート
import type { GreetResponse } from "../gen/greet/v1/greet_pb"; // GreetResponse 型をインポート

// loader関数: ルートがレンダリングされる前に実行され、データを取得する
export async function loader() {
  // TODO: ここでバックエンドAPIを呼び出す
  // const message = "Data from loader (placeholder)"; // 削除
  try {
    /* // fetch を使う部分を削除
    const backendUrl = "http://localhost:8080/greet.v1.GreetService/Greet";
    const response = await fetch(backendUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ name: "Frontend" }), // 送信するデータ
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json() as { greeting: string }; // 型アサーションを追加
    // return { message }; // 変更
    return { message: data.greeting }; // APIからのレスポンスを返す
    */

    // greetClient を使って API を呼び出す
    const response: GreetResponse = await greetClient.greet({ name: "Frontend (Connect)" });
    return { message: response.greeting };

  } catch (error) {
    console.error("Failed to fetch from backend:", error);
    // エラー時はデフォルトメッセージを返す
    return { message: "Failed to load message from API" };
  }
}

// Helloコンポーネント: loaderから受け取ったデータを表示する
// export default function Hello() { // 変更
export default function Hello({ loaderData }: { loaderData: Awaited<ReturnType<typeof loader>> }) {
  // useLoaderDataフックでloaderの戻り値を取得
  // const data = useLoaderData<typeof loader>(); // 削除
  const data = loaderData; // propsから取得

  return (
    <div>
      <h1>Hello Page</h1>
      <p>Message from API: {data.message}</p>
    </div>
  );
} 