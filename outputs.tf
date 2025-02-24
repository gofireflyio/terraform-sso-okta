output "okta_metadata_url" {
  value = okta_app_saml.current.metadata_url
}

output "okta_certificate" {
  value = okta_app_saml.current.certificate
}