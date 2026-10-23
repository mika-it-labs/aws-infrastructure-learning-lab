# 停止・削除・権限整理

## 単発タスクの停止

操作手順で取得した変数を同じPowerShellセッションで使用します。

```powershell
aws ecs stop-task --cluster $cluster --task $taskArn --reason 'Training completed' --profile training --region ap-northeast-1
if ($LASTEXITCODE -ne 0) { throw 'stop-task failed' }
aws ecs wait tasks-stopped --cluster $cluster --tasks $taskArn --profile training --region ap-northeast-1
if ($LASTEXITCODE -ne 0) { throw 'tasks-stopped waiter failed' }
aws ecs list-tasks --cluster $cluster --desired-status RUNNING --profile training --region ap-northeast-1
```

停止要求直後のdesiredStatusだけで完了とせず、待機と残存一覧で確認します。別タスクがある場合は所有者と用途を確認し、今回起動したものだけを停止します。

## 管理リソースの削除

```powershell
terraform plan -destroy
terraform destroy
if ($LASTEXITCODE -ne 0) { throw 'destroy failed; inspect remaining resources' }
terraform state list
if ($LASTEXITCODE -ne 0) { throw 'state inspection failed' }
```

計画を確認してdestroyの確認入力を行います。当日はIAMロール1件が残り、権限見直し後の再実行で削除されました。stateを強制編集して空にする方法は使いません。

既存VPC・サブネットはdata sourceなので削除しません。タスク定義のdestroyは登録解除であり、AWS側にINACTIVE履歴が見える場合があります。空のstateはアカウント全体のリソース不存在を保証しません。

## コンソールと権限整理

東京リージョンでECS稼働タスク・クラスター・CloudWatch Logs・SG、グローバルなIAMで対象実行ロールの残存を確認します。ロググループ削除によりログは失われるため、必要な証跡は事前に匿名化して保存します。

最後に演習用 `Training-ECS-Terraform-Policy` を利用者から取り外し、他の利用・関連付けがなく今後不要な場合のみ削除します。当日は実施者から取り外し・削除済みと報告がありました。AWS管理ポリシーAmazonECSTaskExecutionRolePolicy自体を削除する操作ではありません。

Fargateタスク、public IPv4、ログ等には料金が発生し得ます。保持1日は停止・削除の代わりではありません。課金状況は請求画面で別途確認し、本資料では請求額ゼロを保証しません。
