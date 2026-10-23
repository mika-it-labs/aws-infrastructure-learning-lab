# 構築・操作手順（PowerShell）

以下は当日の操作を再実行しやすく整理した手順です。エラー検査や変数の自動取得は文書化時に補いました。コマンドを実行するとAWS料金が発生し得ます。

## 事前確認と構築

AWS CLI v2、Terraform 1.5以上を用意し、ローカルでtrainingプロファイルを設定します。認証情報はファイル・GitHubへ記載しません。操作先はローカルで確認し、その出力を公開しません。

```powershell
aws sts get-caller-identity --profile training --region ap-northeast-1
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

default VPCが存在し、選択するサブネットにIGWへのデフォルトルート、DNSと必要な外向き通信があることを確認します。コードはVPC内サブネットを検索し、当日は2件でした。常に2件となる保証や順序保証はありません。VPC・サブネット・IGWを新規作成するコードではありません。

## 単発タスク起動

```powershell
$cluster = terraform output -raw cluster_name
$taskDefinition = terraform output -raw task_definition_arn
$subnets = @(terraform output -json subnet_ids | ConvertFrom-Json)
if ($subnets.Count -eq 0) { throw 'No subnet found' }
$subnet = $subnets[0] # ルート等を確認したサブネットを選択
$sg = terraform output -raw security_group_id
$logGroup = terraform output -raw log_group_name
$network = "awsvpcConfiguration={subnets=[$subnet],securityGroups=[$sg],assignPublicIp=ENABLED}"
$result = aws ecs run-task --cluster $cluster --task-definition $taskDefinition --launch-type FARGATE --network-configuration $network --profile training --region ap-northeast-1 --output json
if ($LASTEXITCODE -ne 0) { throw 'run-task failed' }
$run = $result | ConvertFrom-Json
if (@($run.failures).Count -gt 0 -or @($run.tasks).Count -eq 0) { throw 'No task started; inspect failures locally' }
$taskArn = $run.tasks[0].taskArn
aws ecs wait tasks-running --cluster $cluster --tasks $taskArn --profile training --region ap-northeast-1
if ($LASTEXITCODE -ne 0) { throw 'Task did not reach RUNNING; inspect stopped reason' }
```

当日はrun-task応答後にlist-tasksとdescribe-tasksを使用しました。上のtasks-running waiterは再実行時の補助手順です。public IP設定はTerraformタスク定義ではなく、CLIのネットワーク設定で指定します。

## 状態とログ

```powershell
aws ecs list-tasks --cluster $cluster --desired-status RUNNING --profile training --region ap-northeast-1
aws ecs describe-tasks --cluster $cluster --tasks $taskArn --query 'tasks[*].{TaskStatus:lastStatus,DesiredStatus:desiredStatus,HealthStatus:healthStatus,Containers:containers[*].[name,lastStatus,exitCode,reason],StoppedReason:stoppedReason}' --output json --profile training --region ap-northeast-1
aws logs describe-log-streams --log-group-name $logGroup --profile training --region ap-northeast-1
$taskId = ($taskArn -split '/')[-1]
$logStream = "apache/apache/$taskId"
aws logs get-log-events --log-group-name $logGroup --log-stream-name $logStream --query 'events[*].[timestamp,message]' --output table --profile training --region ap-northeast-1
```

タスクとコンテナのRUNNING、Apacheの正常起動メッセージを確認します。ログの到着に時間差がある場合は状態・ストリーム名・実行ロールを確認します。HealthStatus UNKNOWNはHEALTHYの証明ではありません。

SG inboundなしのため、public IPへのブラウザーアクセスは検証対象外です。HTTP疎通のために無条件でポートを開放しません。

## 完了

[停止・削除手順](cleanup.md)に進み、CLIで起動したタスクを停止後、Terraform管理リソースを削除します。原コードは保持し、改善案を実装済みとは扱いません。
