# Firefly SSO OKTA Integration  
# ![Firefly Logo](firefly.gif)

This Terraform module automates the configuration of Okta as an Identity Provider (IdP) for seamless Single Sign-On (SSO) integration with your applications and services.

## Features

- Configures Okta as an Identity Provider for authentication.
- Assigns users directly to the Okta SAML application.
- Create dedicated viewers and admins groups, and assign them to the application.
- Manages Okta application and user/group assignments for enhanced access control.

## Prerequisites

Before using this module, ensure that you have the following:

- **Okta**: An active Okta organization with administrative privileges.
- **Terraform**: Version 1.0 or higher.

## Example Usage

### Create Application and Assign Users Directly
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-okta"
  providers = {
    okta = okta
  }
  app_name             = "demo-firefly"
  domain               = "demo"
  certificate          = var.certificate
  firefly_users_emails = ["user1@demo.com", "user2@demo.com"]
}
```

### Create Application, and Viewers & Admins Groups
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-okta"
  providers = {
    okta = okta
  }
  domain                 = "demo"
  certificate            = var.certificate
  create_admins_group    = true
  create_viewers_group   = true
}
```

### Create Application and Use Existing Groups
```hcl
module "demo-sso-firefly" {
  source = "github.com/gofireflyio/terraform-sso-okta"
  providers = {
    okta = okta
  }
  domain                     = "demo"
  certificate                = var.certificate
  existing_admins_group_name = "Demo-Admins"

}
```

## Variables

The following table outlines the variables available for this module:

| Variable                      | Type          | Required | Description                                                                   | Example Value                          |
|-------------------------------|--------------|----------|-------------------------------------------------------------------------------|----------------------------------------|
| `domain`                      | `string`     | ✅  | The domain name of the organization.       | `"demo"`                               |
| `certificate`                 | `string`     | ✅  | The certificate that was provided by the Firefly team.                        | `(sensitive)`                          |
| `firefly_users_emails`        | `list(string)` | ❌   | List of user email addresses to assign directly to the application.           | `["user1@demo.com", "user2@demo.com"]` |
| `app_name`                    | `string`     | ❌   | The display name of the Okta SAML application. Default: "Firefly". | `"demo-firefly"`                       |
| `create_admins_group`         | `bool`       | ❌   | Creates an administrators group if set to `true`.                             | `true`                                 |
| `new_admins_group_name`       | `string`     | ❌   | Name of the newly created admin group. Default: "Firefly-Admins".             | `"Demo-Admins"`                        |
| `create_viewers_group`        | `bool`       | ❌   | Creates a viewers group if set to `true`.                                     | `true`                                 |
| `new_viewers_group_name`      | `string`     | ❌   | Name of the newly created viewers group. Default: "Firefly-Viewers".          | `"Demo-Viewers"`                       |
| `existing_admins_group_name`  | `string`     | ❌   | Name of a pre-existing admins group to use instead of creating a new one.     | `"Existing-Demo-Admins"`               |
| `existing_viewers_group_name` | `string`     | ❌   | Name of a pre-existing viewers group to use instead of creating a new one.    | `"Existing-Demo-Viewers"`              |

### Notes:
- Ensure that the `domain` matches your organization's domain to enable proper authentication.
- The `certificate` variable is sensitive and should be stored in a secure secret manager (e.g., AWS Secrets Manager, Vault, Azure Key Vault) instead of Terraform code.
- Users specified in `firefly_users_emails` must already exist in Okta before running the Terraform configuration.
- If `create_admins_group` or `create_viewers_group` is set to `true`, the module will create new groups unless `existing_admins_group_name` or `existing_viewers_group_name` is provided.
- To configure SCIM provisioning, please contact the Firefly team for further instructions.
- If you are managing assignments via groups and have customized group names, please provide the exact names to the Firefly team to ensure proper configuration.



## Outputs

```hcl
output "metadata_url" {
  value = module.demo-sso-firefly.metadata_url
}
```

### Output Explanation
- **`metadata_url`**: This URL provides the SAML metadata required for the configured Okta IdP.
    - **Action Required:** Share this URL with the Firefly team to complete the integration process.

