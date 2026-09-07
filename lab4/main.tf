resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

# random string to give the keyvault a unique name!

resource "random_string" "keyvault_suffix" {
  length  = 6
  special = false
  upper   = false
}

# azurerm_client_config is a data source that retrieves information about the AzureRM provider's current configuration. 
# It can be used to access details such as the subscription ID, tenant ID, and other relevant information.
data "azurerm_client_config" "current" {

}

# keyvault

resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  rbac_authorization_enabled = true
  # tenant_id                   = "2de5bb06-69ae-4a32-b2d8-58ecd696c521"  # got this from console Entra ID!
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

}

# role assignment

resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id # current user object id from azurerm_client_config data source
}

data "log_analytics_workspace" "observability" {
  name                = "log-rg-observability-dev"
  resource_group_name = "rg-observability-dev"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "kv-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffix.result}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = data.log_analytics_workspace.observability.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
