output "db_endpoint" {
  description = "The database endpoint"
  value       = aws_challengGCV_db_instance.mysql_instance.endpoint
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "db_username" {
  description = "Database username"
  value       = var.db_username
}

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = aws_apigatewayv2_api.api_gateway.api_endpoint
}