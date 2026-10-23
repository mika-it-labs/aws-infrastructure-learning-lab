# IAM権限不足のトラブルシュート

## 確認できた障害

terraform destroyのIAMロール削除処理で403が発生しました。固有識別子を除いた抜粋です。

```text
operation error IAM: ListInstanceProfilesForRole
AccessDenied: ... not authorized to perform: iam:ListInstanceProfilesForRole
Plan: 0 to add, 0 to change, 1 to destroy.
```

Fargateがインスタンスプロファイルを必要とするという意味ではありません。Terraform providerのロール削除処理が関連付けを調べる際の参照権限不足です。5件の削除後、IAMロールが残って全体は未完了でした。

## 対応と結果

1. エラーの主体、API名、対象ロールを確認。
2. 管理者側で必要な権限を見直す。ログでは変更したポリシーJSONや操作の詳細まで確認できないため、特定のJSONを実際に適用したとは記載しない。
3. terraform plan -destroyで残存1件を確認。
4. 再destroyで `Destroy complete! Resources: 1 destroyed.` を確認。
5. terraform state listが空であることを確認。

stateから強制的に取り除いて完了とせず、AWS側の削除成功を確認することが重要です。

## 再発防止の権限確認（今後の確認観点）

|主体|権限・確認観点|
|---|---|
|Terraform実行者|VPC情報参照、SG操作、ECS登録・参照・削除、Logs操作、IAMロール作成・参照・削除・関連付け|
|CLI実行者|RunTask、DescribeTasks、ListTasks、StopTask、DescribeLogStreams、GetLogEvents、対象ロールへのPassRole|
|execution role|ecs-tasks.amazonaws.comからの信頼とAmazonECSTaskExecutionRolePolicy|

この表は当日の追加エラー一覧ではありません。iam:PassRoleはロールを使わせる権限で、実行ロール自身のログ出力権限とは別です。対象ARNとiam:PassedToService=ecs-tasks.amazonaws.comでの制限を検討します。各APIのResource制限可否に従い、AdministratorAccessを恒久付与しません。
