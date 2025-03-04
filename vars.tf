variable "certificate" {
  type = string
}

variable "domain" {
  type = string
}

variable "users_emails" {
  type = list(string)
}

variable "firefly_users_group_name" {
  type    = string
  default = "Firefly-Admins"
}
