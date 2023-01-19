# creating users asper module or templet which exist users_module
module "ALL_USERS_DEV001" {
  source = "./USERS_MODULE"

  depends_on = [module.snowflake_WAREHOUSE_WH0010.WAREHOUSE]

  user_maps = {

    "snowflake_user10" : {"first_name" = "snowflake_DEV","last_name"="user10","email"="snowflake_DEV_user10@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH0010","default_role"="DB_ADMIN010"},
    "snowflake_user20" : {"first_name" = "snowflake_DEV","last_name"="user20","email"="snowflake_DEV_user20@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH0010","default_role"="DATA_ENGG010"},
    "snowflake_user30" : {"first_name" = "snowflake_DEV","last_name"="user30","email"="snowflake_DEV_user30@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH0010","default_role"="DATA_LOADER010"},
    "snowflake_user40" : {"first_name" = "snowflake_DEV","last_name"="user40","email"="snowflake_DEV_user40@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH0010","default_role"="DATA_ANALYST010"},
    "snowflake_user50" : {"first_name" = "snowflake_DEV","last_name"="user50","email"="snowflake_DEV_user50@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH0010","default_role"="DATA_VIZ010"}

  }
}

output "ALL_USERS_DEV001" {
  value = module.ALL_USERS_DEV001
  sensitive = true
}

# will create a role and asigins to users

module "DB_ADMIN010" {
 source = "./ROLES_MODULE"
 name = "DB_ADMIN010"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user10.name, 
 ]
}

module "DATA_ENGG010" {
 source = "./ROLES_MODULE"
 name = "DATA_ENGG010"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN010"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user20.name,
 ]
}


module "DATA_LOADER010" {
 source = "./ROLES_MODULE"
 name = "DATA_LOADER010"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ENGG010"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user30.name, 
 ]
}

module "DATA_ANALYST010" {
 source = "./ROLES_MODULE"
 name = "DATA_ANALYST010"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN010"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user40.name, 
 ]
}

module "DATA_VIZ010" {
 source = "./ROLES_MODULE"
 name = "DATA_VIZ010"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST010"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user50.name,
 ]
}
  
# will create a warehouse and asign to users a
module "snowflake_WAREHOUSE_WH0010" {
  source            = "./WAREHOUSE_MODULE"
  warehouse_name    = "snowflake_WAREHOUSE_WH0010"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN010","DATA_ENGG010","DATA_ANALYST010","DATA_LOADER010","DATA_VIZ010"]
  }
  with_grant_option = false
}

# will create a database and asign db role grants and also asign schema role grants
module "DATABASE_DEV_DB0010" {
  source = "./DATABASE_MODULE"
  db_name = "DATABASE_DEV_DB0010"
  db_comment = "DATABASE FOR TEST_ENV_DB01"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN010","DATA_ENGG010","DATA_ANALYST010","DATA_LOADER010","DATA_VIZ010"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","DB_ADMIN010"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","DB_ADMIN010"]},
  }
  
}

output "DATABASE_DEV_DB0010" {
  value = module.DATABASE_DEV_DB0010
}


