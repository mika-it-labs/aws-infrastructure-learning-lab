# 公開前チェック

2026年10月23日（JST）の公開準備時に実施。

- 元のTerraform 6ファイルと公開用ファイルの一致を確認。
- terraform fmt -check：成功。
- terraform init：この作業環境のネットワーク制限によりregistry.terraform.ioの名前解決ができず失敗。
- 既存のproviderとlock fileを参照したterraform validate：providerのスキーマ取得時にPlugin did not respondとなり完了できず。validate成功とは扱わない。
- 元のlock fileを収録。取得時はAWS provider 6.70.0。実行時点との同一性は未証明。
- 公開対象のファイル名・本文を検査し、公開禁止の名称、実アカウントID、代表的なAWSキー形式、秘密鍵を検出しないことを確認。
- .terraform、tfstate、tfvars、生ログを含めないことを確認。
- Markdownの相対リンクを確認。
- AWSへのapply・plan・destroyは公開準備時に実行していない。

将来の再実行時は、ネットワーク接続できる環境でinit、validate、planの成功を確認してください。当日の稼働実績と、この公開準備環境の静的検証の成否は別に扱っています。
