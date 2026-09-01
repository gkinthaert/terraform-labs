terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.3.0"  # latest version as of 8/28/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0"  # latest version as of 8/28/2026  
    }
  }
# configure for the dev environment - details on console
  backend "azurerm" {
  }
}



# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}

}