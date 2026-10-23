# 検証結果と根拠

会話添付のテキストログ3件と、ローカルの元Terraformファイルを参照しました。アカウントID、固有ARN、ネットワークID、ユーザー名、ローカルパス、リクエストIDを除いて要約しています。未加工ログは公開しません。

|確認項目|観測結果|根拠・限界|
|---|---|---|
|構築|Apply complete! Resources: 4 added, 0 changed, 0 destroyed.|途中のapply結果。全体が4リソースという意味ではない|
|管理対象|6件|destroy計画と元コード|
|サブネット|outputに2件|既存VPC内検索。作成したものではない|
|起動|failures空、FARGATE、256 CPU、512 MiB|run-task直後はPROVISIONING/PENDING|
|稼働|TaskStatus RUNNING、DesiredStatus RUNNING、apache RUNNING|describe-tasks|
|ヘルス|UNKNOWN|HEALTHYと読み替えない|
|ログ|AH00489: resuming normal operations、AH00094: httpd -D FOREGROUND|get-log-eventsでApache起動確認|
|停止要求|desiredStatus STOPPED、stopCode UserInitiated|応答のlastStatusはまだRUNNING。非同期処理|
|停止待機|tasks-stopped waiterがエラーなく復帰|添付ログ|
|削除|初回はIAMロールで失敗、再計画で1件、再destroyで1件削除|添付ログ|
|state|terraform state listが出力なし|最終ログ。アカウント全体の削除保証ではない|
|演習用権限|一時ポリシー取り外し・削除済み|実施者の会話報告。APIでの再確認なし|

## 時系列（JST）

- 12:34:47頃：単発タスク起動。
- 12:35:09頃：Apache起動。ログ内03:35:09はUTC表記。
- 13:56:55頃：利用者操作による停止要求。
- その後：停止待機、destroy失敗、残存ロール再計画、再destroy成功、state空。

ログ表示のApache版は2.4.69、Fargate platform versionは1.4.0でした。当日の観測値であり、再実行時の同一版を保証しません。

## 未検証

HTTPレスポンス、ALB、負荷耐性、マルチAZ冗長化、自動復旧、コンテナヘルスチェックは未検証です。公開準備時にもAWSへの再実行はしていません。
