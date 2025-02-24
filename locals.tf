locals {
  urn                      = "urn:auth0:prod-infralight:okta"
  subject_name_id_template = "$${user.unspecified}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  single_logout_url        = "https://auth.firefly.ai/logout"
  sso_url                  = "https://auth.firefly.ai/login/callback?connection=okta"
}