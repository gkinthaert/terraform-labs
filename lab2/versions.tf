# setting up the providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5.0" # latest version as of 9/16/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1" # latest version as of 9/16/2026  
    }
  }
}

# Configure the Microsoft Azure Provider
# to get the subscription id, run the following command in the Azure CLI: az account show.
# if you have multiple subscriptions, you can set the subscription id in the provider block or set an environment variable.
# run az account list to see all subscriptions and their ids.
provider "azurerm" {
  features {}
  #subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81"
  #subscription_id = "get the subscription id" better to set an environment variable
  # $env:ARM_SUBSCRIPTION_ID = "subscription id"
}