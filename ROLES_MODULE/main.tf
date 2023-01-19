terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
  }
}


resource "snowflake_role" "ROLE" {
  name = var.name
  comment = var.comment
}

resource "snowflake_role_grants" "ROLE_GRANTS" {
  role_name = snowflake_role.ROLE.name
  roles = var.role_name
  users = var.users
}

output "ROLE" {
  value = snowflake_role.ROLE
}
