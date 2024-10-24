/* 
  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app
  https://www.maxivanov.io/publish-azure-functions-code-with-terraform/
  I manually enabled Application Insights in the console.
  https://www.maxivanov.io/publish-azure-functions-code-with-terraform/ Sounds good but also doesn't work.
  It's starting to get messy. Maybe start again.
*/

data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "./function-app"
  output_path = "function_app.zip"
}

data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.example.primary_connection_string
  container_name    = azurerm_storage_container.example.name

  start = "2023-11-20T17:30:00Z"
  expiry = "2025-12-31T23:59:59Z" # Why would it expire?

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

data "azurerm_storage_account_sas" "example" {
    connection_string = "${azurerm_storage_account.example.primary_connection_string}"
    https_only = true
    start = "2019-01-01"
    expiry = "2021-12-31"
    resource_types {
        object = true
        container = false
        service = false
    }
    services {
        blob = true
        queue = false
        table = false
        file = false
    }
    permissions {
        read = true
        write = false
        delete = false
        list = false
        add = false
        create = false
        update = false
        process = false

        filter = false
        tag = false
    }
}


resource "azurerm_storage_account" "example" {
  name                     = "kinaidaepsilon" # I'm sad that I can't use greek letters. Must be at least three characters. IS this unique?
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}




resource "azurerm_storage_container" "example" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_service_plan" "example" {
  name                = "kinaida-epsilon-app-service-plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "kinaida-epsilon-function-app"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  https_only          = true

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
    ftps_state = "Disabled"
     always_on = false
  }

  app_settings = {
    https_only = true
    FUNCTIONS_WORKER_RUNTIME = "python"
    FUNCTION_APP_EDIT_MODE = "readonly"
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.example.name}.blob.core.windows.net/${azurerm_storage_container.example.name}/${azurerm_storage_blob.example.name}${data.azurerm_storage_account_sas.example.sas}"
    }
}

# Storage blob appears to be how we upload the code. 
resource "azurerm_storage_blob" "example" {
  #name = "${filesha256(data.archive_file.file_function_app.output_path)}.zip"  # data "archive_file" "file_function_app"
  name = "function_app.zip"
  storage_account_name = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type = "Block"
  content_md5            = data.archive_file.file_function_app.output_md5
  source = "./function_app.zip"
}
