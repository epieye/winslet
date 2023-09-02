provider "azurerm" {
  tenant_id       = "2d9699b4-1a62-4b69-b191-8796b219acd4"  # from az login
  subscription_id = "1d1bede6-c63f-4468-9c0b-17d3d9d873cf"  # az account list
  features {}
}


#  client_id       = "c3bcd539-69c3-4100-91fe-d57992aa4ebf"  # Azure Active Directory -> App Registrations
#  client_secret   = "8dd9c393-15df-48e5-973e-acfe3c3bd4d1"  # I created it. Good for 6 months.



provider "aws" {
  region = "us-east-1"
  profile = "OurzooAWSAdministratorAccess"
}

