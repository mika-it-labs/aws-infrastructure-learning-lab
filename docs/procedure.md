# CI・EC2・CodeDeployの復習手順

以下は今後の再学習用手順です。当時の操作を完全再現した記録ではありません。実施済み範囲は[学習記録](learning-record.md)を参照してください。

## 前提

対象アカウント・リージョンをローカルで確認し、専用の学習リソースと権限を用意します。EC2のOSに対応するAgent手順を選び、SSM・S3・CodeDeploy等への通信経路を確認します。操作ログの実識別子は公開しません。

## CI

1. [サンプル](../examples/ci-ec2/README.md)をローカルでテストし、ZIPを生成する。
2. S3ソースバケットのバージョニングを有効にし、決めたキーへソースZIPを置く。公開アクセスは必要ない。
3. CodeBuildに対応するLinux/Pythonランタイムとサービスロールを設定する。単独実行はS3ソース、Pipeline経由はCODEPIPELINEソース・アーティファクトを使用する。
4. CodePipelineでS3 Source → CodeBuild Buildを構成し、入出力アーティファクト名を対応させる。イベント検知かポーリングかを確認する。
5. Pipelineの実行ID、Sourceのリビジョン、Buildのログとテスト結果を確認する。テスト失敗時は先へ進まないことも検証する。
6. 出力アーティファクトにappspec.ymlがルートで入り、相対パスが成立するか確認する。

## EC2とAgent

SSM用インスタンスロールと接続権限、SSM Agent、必要なエンドポイントへのHTTPS通信を確認します。SSHポート開放を前提にしません。CodeDeploy AgentはOS別の公式手順で別途導入します。Linuxでの状態確認例：

```sh
sudo systemctl status amazon-ssm-agent
sudo systemctl status codedeploy-agent
sudo tail -n 100 /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

サービス名・ログパスはOSと導入方法に合わせます。確認出力をそのまま公開しません。

## デプロイ検証（今後の検証・過去の完遂は未確認）

CodeDeployアプリケーションとデプロイグループ、EC2の選択タグ、サービスロール、配布物のS3取得権限を設定します。必要ならPipelineにDeployを追加しBuild出力を渡します。新規サンプルはファイル配置とValidateServiceのみで、Webサービスを起動しません。

デプロイIDと各イベントの成否、配置ファイル、フックの出力を確認します。成功と確認できた範囲のみ記録し、最後に[削除確認](cleanup.md)を行います。

## 公式資料

- [S3 source action](https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-S3.html)
- [Buildspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)
- [AppSpec](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html)
- [CodeDeploy Agent](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent.html)

公式資料は手順の根拠であり、過去の実施結果の証拠ではありません。
