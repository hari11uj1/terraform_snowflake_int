# terraform required provider to access snowflake
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# terraform remote  backend to maintain the state file. It keeps track of all the changes which are preformed through terraform
terraform {
  backend "remote" {
    organization = "SNOWFLAKE_TERRAFORM_INTIGRATION"

    workspaces {
      name = "snowflake_3"
    }
  }
}

provider "azurerm" {
  features {}
}

# data "azurerm_client_config" "current" {}
# to connect to snowflake instance
provider "snowflake" {
 username = data.azurerm_key_vault_secret.test2.value
 account = data.azurerm_key_vault_secret.test1.value
 #role = "accountadmin"
 password = data.azurerm_key_vault_secret.test.value
}


resource "azurerm_resource_group" "app_grp" {
  name = "app_grp"
  location = "North Europe"
}



data "azurerm_key_vault" "example" {
  name                = "CICDTestKVRaj"
  resource_group_name = "CICD_Kroger_Raj_RG"
}

data "azurerm_key_vault_secret" "test" {
  name      = "tf-snowflake-password"
  key_vault_id = data.azurerm_key_vault.example.id

  # vault_uri is deprecated in latest azurerm, use key_vault_id instead.
   #vault_uri = "https://cicdtestkvraj.vault.azure.net/"
}

data "azurerm_key_vault_secret" "test1" {
  name      = "tf-snowflake-account"
  key_vault_id = data.azurerm_key_vault.example.id

  # vault_uri is deprecated in latest azurerm, use key_vault_id instead.
   #vault_uri = "https://cicdtestkvraj.vault.azure.net/"
}

data "azurerm_key_vault_secret" "test2" {
  name = "tf-snowflake-username"
  key_vault_id = data.azurerm_key_vault.example.id
}

output "snowflake_password" {
  value = nonsensitive(data.azurerm_key_vault_secret.test.value)
  
  #sensitive = true
}

output "snowflake_account" {
  value = nonsensitive(data.azurerm_key_vault_secret.test1.value)
  #sensitive = true
}

output "snowflake_username" {
  value = nonsensitive(data.azurerm_key_vault_secret.test2.value)
}

/*output "snowflake_account" {
  
}*/