output "application_name" {
  value = var.application_name
}
output "environment_name" {
  value = var.environment_name
}
output "environment_prefix" {
  value = local.environment_prefix
}
output "suffix" {
  value = random_string.suffix.result
}
output "api_key" {
  value     = var.api_key
  sensitive = true
}

# know that the secret values are stil visible in the terraform.tfstate file 
# and will also
# show when running terraform output api_key