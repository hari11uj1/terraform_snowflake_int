# terraform required provider to access snowflake
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
  }
}

# terraform remote backend to maintain the state file. It keeps track of all the changes which are preformed through terraform
terraform {
  backend "remote" {
    organization = "SNOWFLAKE_TERRAFORM_INTIGRATION"

    workspaces {
      name = "snowflake_dev"
    }
  }
}

# to connect to snowflake instance
provider "snowflake" {
 #username = "HARISHKUMAR2"
 #account = "hy80966.central-india.azure"
 #role = "accountadmin"
 #password = "11Uj1a0318"
}