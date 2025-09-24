terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.45.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "088412f5-0303-4050-9e53-2b794c57b126"
}