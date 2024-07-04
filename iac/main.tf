# CONSULTAR A MAQUI
provider "aws" {
  region      = var.aws_region
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  max_retries = 2

  default_tags {
    tags = var.tags[local.env_name]
  }
}

resource "aws_dynamodb_table" "hilos" {
  name           = "hilos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    department   = "Innovation"
    environment  = "development"
    owner        = "hugox"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "guardar_hilo" {
  filename         = "${path.module}/../src/handlers/guardarHilo.js.zip"
  function_name    = "guardar_hilo"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "guardarHilo.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("${path.module}/../src/handlers/guardarHilo.js.zip")

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "listar_hilo" {
  filename         = "${path.module}/../src/handlers/listarHilo.js.zip"
  function_name    = "listar_hilo"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "listarHilo.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("${path.module}/../src/handlers/listarHilo.js.zip")

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "eliminar_hilo" {
  filename         = "${path.module}/../src/handlers/eliminarHilo.js.zip"
  function_name    = "eliminar_hilo"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "eliminarHilo.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("${path.module}/../src/handlers/eliminarHilo.js.zip")

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "guardar_cambios" {
  filename         = "${path.module}/../src/handlers/guardarCambios.js.zip"
  function_name    = "guardar_cambios"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "guardarCambios.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("${path.module}/../src/handlers/guardarCambios.js.zip")

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

module "api_gateway" {
  source = "api_gateway.tf"
}

data "aws_caller_identity" "current" {}