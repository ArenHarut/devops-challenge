terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.104.0"
    }
  }

  required_version = ">= 1.4.6"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "apvmax-tfstates-rg"
    storage_account_name = "apvmaxtfstatessto"
    container_name       = "terraform-remote-states"
  }
}
