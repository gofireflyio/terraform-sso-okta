// assigning all users directly
data "okta_user" "current" {
  for_each = length(var.firefly_users_emails) > 0 && !var.create_admins_group && length(var.existing_admins_group_name) == 0 && !var.create_viewers_group && length(var.existing_viewers_group_name) == 0 ? toset(var.firefly_users_emails) : toset([])
  search {
    name  = "profile.email"
    value = each.value
  }
}

resource "okta_app_user" "current" {
  for_each = data.okta_user.current
  app_id   = okta_app_saml.current.id
  user_id  = each.value.id
  username = each.value.email
}

// existing groups
data "okta_group" "existing-admins-group" {
  count = length(var.existing_admins_group_name) > 0 && length(var.firefly_users_emails) == 0 && !var.create_admins_group && !var.create_viewers_group ? 1 : 0
  name  = "Firefly-Admins"
}

data "okta_group" "existing-viewers-group" {
  count = length(var.existing_viewers_group_name) > 0 && length(var.firefly_users_emails) == 0 && !var.create_admins_group && !var.create_viewers_group ? 1 : 0
  name  = var.existing_viewers_group_name
}

resource "okta_app_group_assignment" "existing-admins-group-assignment" {
  count    = length(var.existing_admins_group_name) > 0 && length(var.firefly_users_emails) == 0 && !var.create_admins_group && !var.create_viewers_group ? 1 : 0
  app_id   = okta_app_saml.current.id
  group_id = data.okta_group.existing-admins-group[count.index].id
}

resource "okta_app_group_assignment" "existing-viewers-group-assignment" {
  count    = length(var.existing_viewers_group_name) > 0 && length(var.firefly_users_emails) == 0 && !var.create_admins_group && !var.create_viewers_group ? 1 : 0
  app_id   = okta_app_saml.current.id
  group_id = data.okta_group.existing-viewers-group[count.index].id
}

// new groups
resource "okta_group" "firefly-admins-group" {
  count = var.create_admins_group && length(var.firefly_users_emails) == 0 && length(var.existing_admins_group_name) == 0 && length(var.existing_viewers_group_name) == 0 ? 1 : 0
  name  = var.new_admins_group_name
}

resource "okta_group" "firefly-viewers-group" {
  count = var.create_viewers_group && length(var.firefly_users_emails) == 0 && length(var.existing_admins_group_name) == 0 && length(var.existing_viewers_group_name) == 0 ? 1 : 0
  name  = var.new_viewers_group_name
}

resource "okta_app_group_assignment" "firefly-new-admins-group-assignment" {
  count    = var.create_admins_group && length(var.firefly_users_emails) == 0 && length(var.existing_admins_group_name) == 0 && length(var.existing_viewers_group_name) == 0 ? 1 : 0
  app_id   = okta_app_saml.current.id
  group_id = okta_group.firefly-admins-group[0].id
}

resource "okta_app_group_assignment" "firefly-new-viewers-group-assignment" {
  count    = var.create_viewers_group && length(var.firefly_users_emails) == 0 && length(var.existing_admins_group_name) == 0 && length(var.existing_viewers_group_name) == 0 ? 1 : 0
  app_id   = okta_app_saml.current.id
  group_id = okta_group.firefly-viewers-group[0].id
}
#
# resource "okta_app_group_assignment" "Firefly-Admins-assignment" {
#   app_id   = okta_app_saml.current.id
#   group_id = okta_group.Firefly-Admins.id
# }