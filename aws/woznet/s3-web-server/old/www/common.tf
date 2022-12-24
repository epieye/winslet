module "configuration" {
  source = "../../../modules/configuration"

  tags = {
    Application_ID = "None"
    Application_Tier = "None"
    Billing_Owner = "Warren Matthews"
    Business_Unit = "Kinaida"
    Customer = "Internal"
    Functionality_Owner = "IT Ops"
    Environment = "Lab"
  }
}
