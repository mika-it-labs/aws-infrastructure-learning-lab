# CI・EC2向け復習サンプル（今回新規作成）

過去の元ファイルを復元したものではありません。Python標準ライブラリだけでテストし、S3ソースZIPとCodeBuild出力、EC2向けAppSpecの役割を確認します。AWSでの実行・デプロイは未検証です。

## ローカル実行

リポジトリのexamples/ci-ec2へ移動し、Python 3.12を推奨環境として実行します。

```sh
python -m unittest discover -s tests -v
python app.py
python package.py
```

テスト3件と出力5を確認します。package.pyはdist/source.zipを生成し、内容と破損を検査します。ZIPのルートは以下です。

```text
app.py
tests/test_app.py
buildspec.yml
appspec.yml
scripts/validate.sh
```

親フォルダーや認証情報をまとめてZIP化しません。生成物はGitへ追加しません。

## CIとデプロイの境界

S3 SourceとしてソースZIPを指定し、CodeBuildでbuildspec.ymlのテストを実行します。対応するLinuxビルドイメージを選んでください。ビルド出力は配布に必要なファイルのみで、CodeBuild/CodePipelineのアーティファクト設定にも依存します。

EC2での実行はPython 3とCodeDeploy Agentが前提です。AppSpecは/opt/aws-learning-ci-ec2へファイルを配置し、ValidateServiceで配置後のテストと出力確認を行います。フックはrootで実行されるため、内容と配置先をレビューし、学習専用EC2で使用してください。LFを維持します。

Webサーバー、常駐プロセス、HTTPヘルスチェック、ロールバック設計は含みません。ValidateService成功をHTTP疎通成功と扱いません。既存の同名パスがある場合は使用せず、AppSpecとvalidate.shを整合させた別パスを選びます。

AWS側の設定と確認は[復習手順](../../docs/procedure.md)、後片付けは[削除確認](../../docs/cleanup.md)を参照してください。
