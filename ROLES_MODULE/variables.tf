variable "name" {
  type = string
}

variable "comment" {
  type = string
}

variable "role_name" {
  type = list(string)
}

variable "users" {
  type = list(string)
}


variable "roles1" {
  type = map(object({
          role_name= string,
          roles = list(string),
          users= list(string)
  }))
  default = {
    "one" = {
      role_name = "admin9"
      roles = [ "SYSADMIN" ]
      #users = [module.ALL_USERS_DEV001.USERS.snowflake_user30.name,]
    }
  }
}

resource "snowflake_role_grants" "ROLE_GRANTS" {
  for_each = var.roles1
  role_name = each.value["role_name"]
  roles = each.value["roles"]
  users = [module.ALL_USERS_DEV001.USERS.snowflake_user30.name]
}