terraform {
    required_providers {
        azurerm ={
            source = "hashicorp/azurerm"
            version = "~>3.0"
        }
        random={
            source = "hashicorp/random"
            version = "~>3.0"            
        }
    }
    backend "azurerm"{
        resource_group_name = "tfstate-rg"
        storage_account_name = "tfstate8989"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}

provider "azurerm" {
    skip_provider_registration = true
    features{}
}