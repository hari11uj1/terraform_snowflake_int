terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
  }
}

resource "snowflake_database" "DATABASE" {
  name = var.db_name
  comment = var.db_comment
  data_retention_time_in_days = var.db_data_retention_time_in_days
}

resource "snowflake_database_grant" "DATABASE_grant" {
  for_each = var.db_role_grants
  database_name = snowflake_database.DATABASE.name
  privilege = each.key
  roles = each.value
  with_grant_option = false
}

resource "snowflake_schema" "SCHEMA" {
  for_each = toset(var.schemas)
  database = snowflake_database.DATABASE.name
  name = each.key 
}


output "DATABASE" {
  value = snowflake_database.DATABASE
}
output "SCHEMA" {
  value = snowflake_schema.SCHEMA
}
resource "snowflake_schema_grant" "SNOW_SCHEMA_GRANT" {
  for_each = var.schema_grants 
  database_name = snowflake_database.DATABASE.name
  schema_name = split(" ", each.key)[0]
  privilege = join(" ",slice(split(" ",each.key),1, length(split(" ",each.key))))
  roles = each.value.roles
  depends_on = [
    snowflake_schema.SCHEMA
  ]
} 


