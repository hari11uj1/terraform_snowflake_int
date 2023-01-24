# creating users asper module or templet which exist users_module
module "ALL_USERS_DEV001" {
  source = "./USERS_MODULE"

  depends_on = [module.snowflake_WAREHOUSE_WH001.WAREHOUSE]

  user_maps = {

    "snowflake_user1" : {"first_name" = "snowflake_DEV","last_name"="user1","email"="snowflake_DEV_user1@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DB_ADMIN"},
    "snowflake_user2" : {"first_name" = "snowflake_DEV","last_name"="user2","email"="snowflake_DEV_user2@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ENGG"},
    "snowflake_user3" : {"first_name" = "snowflake_DEV","last_name"="user3","email"="snowflake_DEV_user3@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_LOADER"},
    "snowflake_user4" : {"first_name" = "snowflake_DEV","last_name"="user4","email"="snowflake_DEV_user4@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ANALYST"},
    "snowflake_user5" : {"first_name" = "snowflake_DEV","last_name"="user5","email"="snowflake_DEV_user5@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_VIZ"},
    #"snowflake_user30" : {"first_name" = "snowflake_DEV","last_name"="user30","email"="snowflake_DEV_user30@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_LOADER"}

  }
}

output "ALL_USERS_DEV001" {
  value = module.ALL_USERS_DEV001
  sensitive = true
}

# will create a role and asigins to users

module "DB_ADMIN" {
 source = "./ROLES_MODULE"
 name = "DB_ADMIN"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user1.name, 
 ]
}

module "DATA_ENGG" {
 source = "./ROLES_MODULE"
 name = "DATA_ENGG"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user2.name,
 ]
}


module "DATA_LOADER" {
 source = "./ROLES_MODULE"
 name = "DATA_LOADER"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ENGG"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user3.name, 
 ]
}

module "DATA_ANALYST" {
 source = "./ROLES_MODULE"
 name = "DATA_ANALYST"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user4.name, 
 ]
}

module "DATA_VIZ" {
 source = "./ROLES_MODULE"
 name = "DATA_VIZ"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user5.name,
 ]
}

/*module "DATA_LOADER010" {
 source = "./ROLES_MODULE"
 name = "DATA_LOADER010"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ENGG010"]
 /*users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user30.name, 
 ]
}*/

/*resource "snowflake_user_grant" "grant" {
  user_name = "snowflake_user30"

  roles = ["DATA_LOADER"]

  with_grant_option = false
}*/
  
# will create a warehouse and asign to users a
module "snowflake_WAREHOUSE_WH001" {
  source            = "./WAREHOUSE_MODULE"
  warehouse_name    = "snowflake_WAREHOUSE_WH001"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN","DATA_ENGG","DATA_ANALYST","DATA_LOADER","DATA_VIZ"]
  }
  with_grant_option = false
}

# will create a database and asign db role grants and also asign schema role grants
module "DATABASE_DEV_DB001" {
  source = "./DATABASE_MODULE"
  db_name = "DATABASE_DEV_DB001"
  db_comment = "DATABASE FOR TEST_ENV_DB01"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN","DATA_ENGG","DATA_ANALYST","DATA_LOADER","DATA_VIZ"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","DB_ADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","DB_ADMIN"]},
  }
  
}

output "DATABASE_DEV_DB001" {
  value = module.DATABASE_DEV_DB001
}


