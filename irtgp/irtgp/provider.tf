provider "aws" {
  region = "us-east-1"
  profile = "OurzooAWSAdministratorAccess"
}

#provider "aws" {
#  alias  = "Auckland"
#  region = "ap-southeast-6"
#}

##provider "aws" {
##  alias  = "Capetown"
##  region = "af-south-1"
##}

provider "aws" {
  alias   = "London"
  region  = "eu-west-2"
  profile = "OurzooAWSAdministratorAccess"
}

provider "aws" {
  alias   = "Auckland"
  region  = "ap-southeast-6"
  profile = "OurzooAWSAdministratorAccess"
}

