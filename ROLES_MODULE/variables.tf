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