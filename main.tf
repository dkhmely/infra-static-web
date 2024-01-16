resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "static-web-rg"
}

resource "random_string" "sa_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = random_string.sa_name.result

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = "devops01-cdn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = "devops01-endpoint"
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  origin_host_header  = azurerm_storage_account.sa.primary_web_host

  origin {
    name      = "HelloThere"
    host_name = azurerm_storage_account.sa.primary_web_host
  }
}