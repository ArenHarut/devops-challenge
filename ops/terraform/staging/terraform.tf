terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }

  required_version = ">= 1.9.0"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "apvmax-tfstates-rg"
    storage_account_name = "apvmaxtfstatessto"
    container_name       = "terraform-remote-states"
    key                  = "approvalmax/staging-azfunction.tfstate"
  }
}
