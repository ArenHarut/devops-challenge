provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "main-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "main" {
  name                     = "${local.resource_prefix}linuxfapsa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "main" {
  name                = "${local.resource_prefix}-app-service-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

locals {
  resource_prefix = "approvalmax"
  default_tags = {
    app = "streaming"
    tier = "business"
    dept = "R&D"
  }
}

resource "azurerm_linux_function_app" "main" {
  name                       = "${local.resource_prefix}-realtime-processing-svc"
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
