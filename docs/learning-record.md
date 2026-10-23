# 学習内容と実施範囲

## 記録の読み方

「実施済み」は本人申告に基づく分類です。今回取得できた実行ログでの独立検証ではありません。「復習手順」「新規サンプル」「今後の計画」は実施済みの証拠に数えません。旧ECS記録は[保管版](../archive/ecs-terraform-original/README.md)で区別します。

## 1. S3・CodeBuild・CodePipeline CI（実施済み）

S3へ配置するソースZIP、CodeBuildで実行するビルド・Pythonテスト、CodePipelineでのSource/Buildの連携を学習しました。制御の主体はCodePipelineで、データの流れはS3ソース → Sourceアーティファクト → CodeBuild → Buildアーティファクトです。S3がCodeBuildとCodePipelineを直列に直接呼ぶという意味ではありません。

実際のバケット名、オブジェクトキー、バージョニング設定、起動検知方式、サービスロール、実行ID、結果件数は未取得です。CIを学習した事実から自動デプロイの成功は推定しません。

## 2. EC2・SSM・CodeDeploy Agent（実施済み）

EC2を対象にSSMによる管理・接続とCodeDeploy Agentを扱いました。SSM AgentとCodeDeploy Agentは別です。SSMで接続できてもCodeDeploy Agentやデプロイの正常性までは証明しません。

実際のAMI、OS、インスタンスタイプ、ネットワーク、インスタンスプロファイル、Agentの導入方法・版・稼働ログは未取得です。Apache・Tomcat・PostgreSQLの導入・連携完了も、本記録では確認できていません。

## 3. Python・AppSpec・検証・ZIP（実施済み）

Pythonテスト、EC2向けappspec.yml、validate.sh、ZIPの作成・利用を学習しました。元コード、テストフレームワーク、ケース数、実際のフック名や配置先は不明です。[サンプル](../examples/ci-ec2/README.md)はこれらの役割を復習するため今回新規作成しています。

テスト成功、フック成功、デプロイ成功、HTTP疎通成功は異なる確認項目です。AppSpecが存在するだけではデプロイ成功とは言えません。

## 4. IAM・削除確認（実施済み）

各サービスの実行主体と権限、作成後のリソース削除確認を学習しました。実際に付与したポリシーJSON、発生したAccessDenied、削除対象一覧・完了ログは未取得です。具体的な障害原因や完全削除を断定しません。

## 5. 未実施・未確認

今回の学習としてのECS/Terraformは計画段階です。ECR push、Fargate起動、Terraform apply/destroy、ECSサービス・ALB、性能・冗長化検証の実施を主張しません。CodeDeployによるEC2への配布完遂も未確認です。

## 次回残す証跡

匿名化したSource/Build実行結果、Pythonテストの実際の出力、EC2・各Agentの状態、使用したAppSpecとフック、ZIPの内容一覧、必要であればデプロイIDとライフサイクルイベント、削除前後の対象一覧を残します。実ID、認証情報、生ログは公開せず、日付・対象範囲・成功/失敗・未確認事項を記録します。
