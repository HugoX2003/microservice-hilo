data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "development_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_caller_identity" "current" {}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "bin/lambda_function_payload.zip"
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "lambda_dynamodb_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ],
        "Resource": [
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.hilos.name}"
        ]
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "guardar_hilo" {
  filename      = data.archive_file.lambda.output_path
  function_name = "guardar_hilo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handlers/guardarHilo.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "listar_hilo" {
  filename      = data.archive_file.lambda.output_path
  function_name = "listar_hilo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handlers/listarHilo.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "eliminar_hilo" {
  filename      = data.archive_file.lambda.output_path
  function_name = "eliminar_hilo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handlers/eliminarHilo.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}

resource "aws_lambda_function" "guardar_cambios" {
  filename      = data.archive_file.lambda.output_path
  function_name = "guardar_cambios"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handlers/guardarCambios.handler"
  runtime       = "nodejs18.x"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      THREADS_TABLE = aws_dynamodb_table.hilos.name
    }
  }
}