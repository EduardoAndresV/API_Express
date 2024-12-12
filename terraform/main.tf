terraform {
  #Especificar los proveedores de infraestructura
  required_providers {
    aws = {
      source = "hashicorp"
      version = "4.61.0"
    }
  }
  required_version = ">= 1.10.0"
}

#Configurar región 
provider "aws" {
  region = var.region
}

# Crear un rol IAM para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "nodejs_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

# Adjuntar políticas al rol
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Crear la función Lambda con el código Node.js
resource "aws_lambda_function" "api_lambda" {
  function_name    = "nodejs-api-lambda"
  runtime          = "nodejs22.12" 
  handler          = "index.handler"
  role             = aws_iam_role.lambda_role.arn
  filename         = "Proyecto_ChallengeGCV.zip"
  source_code_hash = filebase64sha256("Proyecto_ChallengeGCV.zip")
}

# Configurar API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "nodejs-api-gateway"
  protocol_type = "HTTP"
}

# Integrar API Gateway con Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.api_lambda.invoke_arn
}

# Crear la ruta para la API
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}" 
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Crear una etapa de despliegue para la API
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

# Permitir a API Gateway invocar la Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

resource "aws_db_instance" "mysql_instance" {
  allocated_storage      = var.allocated_storage
  instance_class         = var.db_instance_class
  engine                 = var.engine
  engine_version         = var.engine_version
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"] # Ejemplo de CIDR
  }

  egress {
   from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}