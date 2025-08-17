# Terraform MSGraph Identity Automation Demo

This Terraform configuration demonstrates how to manage Microsoft Entra ID (formerly Azure Active Directory) resources using the `azuread` and `msgraph` providers.

## Resources Managed

This configuration creates the following resources:

*   **Two Azure AD Users:**
    *   `alicej@yourdomain.com`
    *   `reviewer@yourdomain.com`
*   **An Azure AD Group:**
    *   "Test Review Group"
*   **An Access Review Definition:**
    *   A weekly access review for the "Test Review Group".

## Providers

While the `hashicorp/azuread` Terraform provider is excellent for managing core Microsoft Entra ID objects like users, groups, and service principals, it does not currently support the creation and management of Azure AD Access Reviews. This is a known limitation, and there is an open feature request for this functionality on the provider's GitHub repository. For advanced Identity Governance features like Access Reviews, the recommended solution is to use the `Microsoft/msgraph` provider. This provider offers comprehensive coverage of the Microsoft Graph API, including the necessary resources for managing access reviews. In this example, I have demonstrated how to use the `msgraph` provider to create an access review.

## Permissions Required

To apply this Terraform configuration, the service principal or user running Terraform needs the following Microsoft Graph permissions:

*   **User.ReadWrite.All:** To create and manage users.
*   **Group.ReadWrite.All:** To create and manage groups.
*   **AccessReview.ReadWrite.All:** To create and manage access reviews.

## How to Use

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
2.  **Apply the configuration:**
    ```bash
    terraform apply
    ```

**Note:** This configuration uses plain text passwords for the users. This is not recommended for production environments. Consider using a more secure method for managing secrets, such as Azure Key Vault.
