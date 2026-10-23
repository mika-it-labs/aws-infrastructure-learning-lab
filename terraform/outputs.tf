output "cluster_name" {
  value = aws_ecs_cluster.training.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.apache.arn
}

output "subnet_ids" {
  value = data.aws_subnets.default.ids
}

output "security_group_id" {
  value = aws_security_group.ecs.id
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}