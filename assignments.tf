data "okta_user" "current" {
  for_each = toset(var.users_emails)
  search {
    name  = "profile.email"
    value = each.value
  }
}

resource "okta_group" "firefly-admins" {
  name        = var.firefly_users_group_name
  description = "Firefly Admin Users"
}

resource "okta_group_memberships" "firefly-admins-members" {
  group_id = okta_group.firefly-admins.id
  users = [
    for user in data.okta_user.current : user.id
  ]
}

resource "okta_app_group_assignment" "firefly-admins-assignment" {
  app_id   = okta_app_saml.current.id
  group_id = okta_group.firefly-admins.id
}