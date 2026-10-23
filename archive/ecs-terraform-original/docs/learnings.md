# 気づき・学び・所感

## コードと運用をつなぐ

Terraformはクラスターやタスク定義を管理し、当日の単発タスク起動はCLIで行いました。定義の存在と稼働は別です。単発タスクはstateの管理外なので、destroy前にCLIで停止する必要があります。

## 状態とログを合わせて確認する

run-task成功直後はPROVISIONING/PENDINGでした。describe-tasksのRUNNINGとCloudWatch LogsのApache起動ログを組み合わせました。HealthStatus UNKNOWNをHEALTHYとみなさず、HTTP疎通確認の代わりにもしていません。

## ネットワークとIAM

public IP有効でもSGのinboundがなければ外部からHTTP接続できません。外向き通信はルート・IGW・SG等に依存します。操作利用者、タスク実行ロール、アプリ用task roleを分けて理解する必要があります。本コードにはtask roleを設定していません。

## 削除までを完了条件にする

削除にも関連付けの参照権限が必要でした。失敗時はエラーと残存計画を読み、再実行後にstateを確認します。ログ保持1日はタスク停止やロググループ削除の代わりにはなりません。

## 今後の改善案（未実装）

- サブネットを明示し、ルートとAZを事前検証する。
- provider lock fileとコンテナdigestを固定して再現性を高める。
- HTTP疎通が必要な演習ではアクセス元を絞ったSGとヘルスチェックを設計する。
- 本番用には専用VPC、private subnet、VPC endpoints/NAT、ECS service、ALB、複数AZを要件に応じて検討する。
- 作成・更新・削除を含む最小権限と匿名化した証跡保存を手順化する。
