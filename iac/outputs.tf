# POSIBLEMENTE COMPLETO

# Salida 'guardar_hilo_lambda'
output "guardar_hilo_lambda" {
  value = aws_lambda_function.guardar_hilo.arn
}

#Salida 'listar_hilo_lambda'
output "listar_hilo_lambda" {
  value = aws_lambda_function.listar_hilo.arn
}

# Salida 'eliminar_hilo_lambda'
output "eliminar_hilo_lambda" {
  value = aws_lambda_function.eliminar_hilo.arn
}

# Salida 'guardar_cambios_lambda'
output "guardar_cambios_lambda" {
  value = aws_lambda_function.guardar_cambios.arn
}

# Salida 'api_gateway_url'
output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.hilo_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}