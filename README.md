# AWS CI/CD・EC2 学習記録とECS/Terraform実演記録

S3、CodeBuild、CodePipelineによるCIと、EC2・SSM・CodeDeploy Agentに関する学習

## 実施状況

|項目|状態|記録の根拠・範囲|
|---|---|---|
|S3 → CodeBuild → CodePipeline CI|実施済み（本人申告）|S3のソースをCodePipelineで受け渡し、CodeBuildで処理する学習。実行ID・成功ログは今回未取得|
|EC2＋SSM＋CodeDeploy Agent|実施済み（本人申告）|インスタンス、接続・管理、Agentに関する学習。OS、Agent版、現在の状態は未確認|
|Pythonテスト、appspec.yml、validate.sh、ZIP|実施済み（本人申告）|テストと配布物・検証スクリプトの学習。元ファイルの完全な内容は未取得|
|IAM、削除確認|実施済み（本人申告）|権限設定と後片付けの学習。実ポリシー・全削除・請求額ゼロは未確認|
|CodePipelineからEC2への自動デプロイ完遂|未確認|CIの実施とAgentの準備を、CD全体の成功と読み替えない|
|ECS/Fargate・Terraform|この学習記録では計画段階|既存リポジトリには別の実施済み記述がある。下記の出所説明を参照|

## 資料

- [学習内容・到達点・証拠の限界](docs/learning-record.md)
- [CI・EC2・CodeDeployの復習手順](docs/procedure.md)
- [IAMの役割と権限の確認](docs/iam.md)
- [障害の切り分け](docs/troubleshooting.md)
- [削除・残存・料金の確認](docs/cleanup.md)
- [検証範囲](docs/verification.md) / [公開時の確認](docs/publication-checks.md)
- [ECS/Terraformの今後の計画](docs/ecs-terraform-plan.md)
- [新規作成した学習用サンプル](examples/ci-ec2/README.md)
- [学習サマリー](docs/summary.md) / [学び](docs/learnings.md)

## 出所と既存内容の保護

今回の実施状況は本人から提示された範囲に基づきます。参照会話の取得結果には過去の詳細作業ログが含まれず、応答本文も参照マーカーのみでした。具体的な時刻、テスト件数、設定値、成功メッセージを補っていません。

既存版はECS/Fargate・Terraformを実施済みと記載していました。今回の指定と相違するため、[元README](archive/ecs-terraform-original/README.md)と元docsを原文保存し、現行の記録とは分離しました。既存記録のログ自体を今回再検証したわけではありません。既存の[Terraformコード](terraform/)とlock fileは変更せず保持しています。コードの存在は、この学習でapplyを実施した証拠にはしません。

サンプルは今回新規作成した復習用コードです。当時のコードの復元でも、AWSで動作確認済みの成果物でもありません。AWSリソースの作成・削除はこの更新作業では実行していません。

## 名称

リポジトリ名は `aws-infrastructure-learning-lab` です。2026年10月23日（JST）に `aws-ecs-fargate-terraform-lab` から変更しました。
