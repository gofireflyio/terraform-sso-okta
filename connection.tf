resource "okta_app_saml" "current" {
  label                     = var.app_name
  sso_url                   = "${local.sso_url}-${var.domain}"
  logo                      = "${path.module}/utility/logo.png"
  recipient                 = "${local.sso_url}-${var.domain}"
  destination               = "${local.sso_url}-${var.domain}"
  audience                  = "${local.urn}-${var.domain}"
  subject_name_id_template  = local.subject_name_id_template
  subject_name_id_format    = local.subject_name_id_format
  response_signed           = true
  single_logout_url         = local.single_logout_url
  single_logout_issuer      = "${local.urn}-${var.domain}"
  assertion_signed          = true
  single_logout_certificate = var.certificate
  signature_algorithm       = local.signature_algorithm
  digest_algorithm          = local.digest_algorithm
  honor_force_authn         = true
  authn_context_class_ref   = local.authn_context_class_ref

  attribute_statements {
    name   = "email"
    values = ["user.email"]
  }

  attribute_statements {
    name   = "name"
    values = ["user.firstName"]
  }
  dynamic "attribute_statements" {
    for_each = length(var.firefly_users_emails) == 0 ? [1] : []
    content {
      type         = "GROUP"
      name         = "groups"
      filter_type  = "CONTAINS"
      filter_value = "Firefly"
    }
  }
}


