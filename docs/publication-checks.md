# 今回の公開時チェック（2026年10月23日 JST）

- GitHub mainの既存ファイルを読み、旧README・docs 8ファイルを本文変更なしでarchive/ecs-terraform-original/へ保存する構成を確認。
- 既存Terraform 6ファイル、lock fileは変更対象外。
- Python 3.12.14で新規サンプルのunittest 3件成功。app.pyの出力5を確認。
- package.pyは実行したが、この環境でのファイル作成・書き込みエラー（FileNotFoundError、Bad file descriptor）によりZIP生成を完了できず。ZIP生成成功とは扱わない。
- validate.shのbash構文検査は環境のBash/E_ACCESSDENIEDにより実行不可。EC2でのフック実行も未確認。
- CodeBuild、CodePipeline、CodeDeploy、SSM、AWS上のリソースや料金は今回検証していない。
- 新規・更新ファイルに企業名・顧客名、実アカウントID、秘密鍵、代表的なAWSアクセスキー形式を含めないことを確認。
- 記録の根拠、本人申告、未確認、計画、新規サンプル、旧記録を明示。
- リポジトリ名称変更は接続ツールに対応操作がなく未実施。推奨名のみREADMEに記載。

旧検査記録は[保管版](../archive/ecs-terraform-original/docs/publication-checks.md)です。過去の検査成功を今回の検査結果に置き換えていません。
