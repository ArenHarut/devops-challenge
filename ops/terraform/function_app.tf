resource "azurerm_linux_function_app" "main" {
  name                       = "${local.resource_prefix}-realtime-processing-service"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  tags                       = local.default_tags

  https_only                  = true
  functions_extension_version = "~4"

  site_config {
    http2_enabled       = true
    use_32_bit_worker   = false
    minimum_tls_version = "1.2"

    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    WEBSITE_MOUNT_ENABLED = "1",
  }
}
