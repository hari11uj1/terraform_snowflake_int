# creating users asper module or templet which exist users_module
# creating groups of users,all users will get created here with a default warehouse and a role .
module "ALL_USERS_DEV001" {
  source = "./USERS_MODULE"

  depends_on = [module.snowflake_WAREHOUSE_WH001.WAREHOUSE]

  user_maps = {

    "snowflake_user1" : {"first_name" = "snowflake_DEV","last_name"="user1","email"="snowflake_DEV_user1@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DB_ADMIN"},
    "snowflake_user2" : {"first_name" = "snowflake_DEV","last_name"="user2","email"="snowflake_DEV_user2@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ENGG"},
    "snowflake_user3" : {"first_name" = "snowflake_DEV","last_name"="user3","email"="snowflake_DEV_user3@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_LOADER"},
    "snowflake_user4" : {"first_name" = "snowflake_DEV","last_name"="user4","email"="snowflake_DEV_user4@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ANALYST"},
    "snowflake_user5" : {"first_name" = "snowflake_DEV","last_name"="user5","email"="snowflake_DEV_user5@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_VIZ"},
    "snowflake_user30" : {"first_name" = "snowflake_DEV","last_name"="user30","email"="snowflake_DEV_user30@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_LOADER"}

  }
}

output "ALL_USERS_DEV001" {
  value = module.ALL_USERS_DEV001
  sensitive = true
}


# Roles and Role_grants are granted here 
# 1. will create a role and will grant  role to roles and a users

module "DB_ADMIN" {
 source = "./ROLES_MODULE"
 name = "DB_ADMIN"
 comment = "a role for DB_ADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user1.name, 
 ]
}
# Creating a DATA_ENGG role and role_granting to DATA_ENGG
module "DATA_ENGG" {
 source = "./ROLES_MODULE"
 name = "DATA_ENGG"
 comment = "a role for DATA_ENGG inc"
 role_name = ["DB_ADMIN"]
 users = [
  module.ALL_USERS_DEV001.USERS.snowflake_user2.name,
 ]
}


module "DATA_LOADER" {
 source = "./ROLES_MODULE"
 name = "DATA_LOADER"
 comment = "a role for DATA_LOADER "
 role_name = ["DATA_ENGG"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user3.name, 
 ]
}

module "DATA_ANALYST" {
 source = "./ROLES_MODULE"
 name = "DATA_ANALYST"
 comment = "a role for DATA_ANALYST inc"
 role_name = ["DB_ADMIN"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user4.name, 
 ]
}

module "DATA_VIZ" {
 source = "./ROLES_MODULE"
 name = "DATA_VIZ"
 comment = "a role for DATA_VIZ inc"
 role_name = ["DATA_ANALYST"]
 users = [
  #module.ALL_USERS_DEV001.USERS.snowflake_user5.name,
 ]
}

resource "snowflake_role" "ROLE" {
  name = "admin_12"
  comment = "this is a sample role"
}


resource "snowflake_role_grants" "ROLE_GRANTS" {
  role_name = snowflake_role.ROLE.name
  roles = ["SYSADMIN"]
  users = [module.ALL_USERS_DEV001.USERS.snowflake_user30.name]
}

resource "snowflake_role" "ROLE1" {
  name = "admin9"
  comment = "this is a sample role"
}

resource "snowflake_role_grants" "ROLE_GRANTS1" {
  for_each = var.roles1
  role_name = each.value["role_name"]
  roles = each.value["roles"]
  users = [module.ALL_USERS_DEV001.USERS.snowflake_user30.name]
  depends_on = [snowflake_role.ROLE1]
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
  
# Will create a warehouse and asign to users a
# Creating a warehouse and also doing warehouse_grant to specific roles with privileges access
module "snowflake_WAREHOUSE_WH001" {                                                             # NAME OF THE MODULE
  source            = "./WAREHOUSE_MODULE"                                                       # THIS IS THE SOURCE OF THE MODULE
  warehouse_name    = "snowflake_WAREHOUSE_WH001"                                                # THIS IS THE NAME OF THE WAREHOUSE 
  warehouse_size    = "SMALL"                                                                    # THIS IS THE REQUIRED SIZE OF THE WAREHOUSE
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],                                                                  # HERE WE WILL GIVE THE WAREHOUSE_GRANT AND PREVILEGE FOR PERTICULAR ROLES
    "USAGE" = ["SYSADMIN","DB_ADMIN","DATA_ENGG","DATA_ANALYST","DATA_LOADER","DATA_VIZ"]
  }
  with_grant_option = false
}

# Creating a database and also doing a database_role_grants to specific roles with previleges access
# Also create schema and grant those schemas to roles with schema_previleges
module "DATABASE_DEV_DB001" {                                                                      # NAME OF THE MODULE      
  source = "./DATABASE_MODULE"                                                                     # THIS IS THE SOURCE OF THE MODULE               
  db_name = "DATABASE_DEV_DB001"                                                                   # NAME OF THE DATABASE
  db_comment = "DATABASE FOR TEST_ENV_DB01"                                                        # COMMENT ON DATABASE
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN","DATA_ENGG","DATA_ANALYST","DATA_LOADER","DATA_VIZ"]          # DATABASE GRANTS AND PREVILEGES FOR SPECIFIC ROLES
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]                                                       # THIS IS THE DATABASE SCHEMAS
  schema_grants = {                   
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","DB_ADMIN"]},                                      # THIS IS THE SCHEMA GRANTS AND  PREVILEGES TO SPECIFIC ROLES
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","DB_ADMIN"]},
  }
  
}

output "DATABASE_DEV_DB001" {
  value = module.DATABASE_DEV_DB001
}


