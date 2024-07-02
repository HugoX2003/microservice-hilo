# POSIBLEMENTE COMPLETO

# API Gateway
resource "aws_api_gateway_rest_api" "hilo_api" {
  name        = "HiloAPI"
  description = "API para el servicio de hilos"
}

resource "aws_api_gateway_resource" "hilo" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  parent_id   = aws_api_gateway_rest_api.hilo_api.root_resource_id
  path_part   = "hilo"
}
# Configuración del Método POST para guardarHilo
resource "aws_api_gateway_method" "guardar_hilo" {
  rest_api_id   = aws_api_gateway_rest_api.hilo_api.id
  resource_id   = aws_api_gateway_resource.hilo.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "guardar_hilo" {
  rest_api_id             = aws_api_gateway_rest_api.hilo_api.id
  resource_id             = aws_api_gateway_resource.hilo.id
  http_method             = aws_api_gateway_method.guardar_hilo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.guardar_hilo.invoke_arn
}

resource "aws_api_gateway_method_response" "guardar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.guardar_hilo.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "guardar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.guardar_hilo.http_method
  status_code = aws_api_gateway_method_response.guardar_hilo_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
  aws_api_gateway_integration.guardar_hilo
  ]
}

resource "aws_lambda_permission" "guardar_hilo_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardar_hilo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hilo_api.execution_arn}/*/*"
}

# Configuración del Método DELETE para eliminarHilo
resource "aws_api_gateway_method" "eliminar_hilo" {
  rest_api_id        = aws_api_gateway_rest_api.hilo_api.id
  resource_id        = aws_api_gateway_resource.hilo.id
  http_method        = "DELETE"
  authorization      = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "eliminar_hilo" {
  rest_api_id             = aws_api_gateway_rest_api.hilo_api.id
  resource_id             = aws_api_gateway_resource.hilo.id
  http_method             = aws_api_gateway_method.eliminar_hilo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.eliminar_hilo.invoke_arn
  request_parameters      = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

resource "aws_api_gateway_method_response" "eliminar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.eliminar_hilo.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "eliminar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.eliminar_hilo.http_method
  status_code = aws_api_gateway_method_response.eliminar_hilo_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.eliminar_hilo
  ]
}

resource "aws_lambda_permission" "eliminar_hilo_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eliminar_hilo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hilo_api.execution_arn}/*/*"
}

# Configuración del Método PUT para guardarCambios
resource "aws_api_gateway_method" "guardar_cambios" {
  rest_api_id   = aws_api_gateway_rest_api.hilo_api.id
  resource_id   = aws_api_gateway_resource.hilo.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "guardar_cambios" {
  rest_api_id             = aws_api_gateway_rest_api.hilo_api.id
  resource_id             = aws_api_gateway_resource.hilo.id
  http_method             = aws_api_gateway_method.guardar_cambios.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.guardar_cambios.invoke_arn
}

resource "aws_api_gateway_method_response" "guardar_cambios_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.guardar_cambios.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "guardar_cambios_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.guardar_cambios.http_method
  status_code = aws_api_gateway_method_response.guardar_cambios_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.guardar_cambios
  ]
}

resource "aws_lambda_permission" "guardar_cambios_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardar_cambios.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hilo_api.execution_arn}/*/*"
}

# Configuración del Método GET para listarHilo
resource "aws_api_gateway_method" "listar_hilo" {
  rest_api_id   = aws_api_gateway_rest_api.hilo_api.id
  resource_id   = aws_api_gateway_resource.hilo.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "listar_hilo" {
  rest_api_id             = aws_api_gateway_rest_api.hilo_api.id
  resource_id             = aws_api_gateway_resource.hilo.id
  http_method             = aws_api_gateway_method.listar_hilo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.listar_hilo.invoke_arn
}

resource "aws_api_gateway_method_response" "listar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.listar_hilo.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "listar_hilo_200" {
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  resource_id = aws_api_gateway_resource.hilo.id
  http_method = aws_api_gateway_method.listar_hilo.http_method
  status_code = aws_api_gateway_method_response.listar_hilo_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.listar_hilo
  ]
}

resource "aws_lambda_permission" "listar_hilo_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.listar_hilo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hilo_api.execution_arn}/*/*"
}

#Despliegue de la API
resource "aws_api_gateway_deployment" "hilo_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.guardar_hilo,
    aws_api_gateway_integration.eliminar_hilo,
    aws_api_gateway_integration.guardar_cambios,
    aws_api_gateway_integration.listar_hilo
  ]
  rest_api_id = aws_api_gateway_rest_api.hilo_api.id
  stage_name  = "prod"
}
