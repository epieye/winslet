provider "aws" {
  region = "us-east-2"
  profile = "OurzooAWSAdministratorAccess"
}

provider "azurerm" {
  tenant_id       = "2d9699b4-1a62-4b69-b191-8796b219acd4"  # from az login
  subscription_id = "1d1bede6-c63f-4468-9c0b-17d3d9d873cf"  # az account list
  features {}
}
