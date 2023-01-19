terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
  }
}

resource "snowflake_user" "USERS" {
  for_each = var.user_maps
  first_name = each.value.first_name
  last_name = each.value.last_name
  email = each.value.email
  login_name = each.key
  default_warehouse = lookup(each.value,"default_warehouse","NONE") == "NONE" ? "COMPUTE_WH" : each.value.default_warehouse 
  default_role = lookup(each.value,"default_role","NONE") == "NONE" ? "PUBLIC" : each.value.default_role 
  name = each.key
  display_name = "${each.value.first_name} ${each.value.last_name}"
}

output "USERS" {
  value = snowflake_user.USERS
}
