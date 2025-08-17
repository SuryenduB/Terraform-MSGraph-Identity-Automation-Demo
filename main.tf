terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    msgraph = {
      source = "Microsoft/msgraph"
    }
  }
}

provider "azuread" {
  # This provider will use the same authentication as the msgraph provider.
  # You can configure it explicitly or use environment variables.
}

provider "msgraph" {
  # This provider will use the same authentication as the azuread provider.
  # You can configure it explicitly or use environment variables.
}

resource "azuread_user" "user" {
  user_principal_name = "alicej@yourdomain.com"
  display_name        = "Alice Johnson"
  mail_nickname       = "alicej"
  password            = "P@ssw0rd123!" # Note: Storing passwords in plain text is not recommended.
  force_password_change = true
  account_enabled     = true
}

resource "azuread_user" "reviewer_user" {
  user_principal_name = "reviewer@yourdomain.com"
  display_name        = "Reviewer User"
  mail_nickname       = "reviewer"
  password            = "Str0ngP@ssw0rd456!" # Note: Storing passwords in plain text is not recommended.
  force_password_change = true
  account_enabled     = true
}

resource "azuread_group" "group" {
  display_name     = "Test Review Group"
  security_enabled = true
  mail_enabled     = false
  mail_nickname    = "mygroup"
  owners           = [azuread_user.user.object_id]
  members          = [azuread_user.user.object_id]
}

resource "msgraph_resource" "access_review_definition" {
  url = "identityGovernance/accessReviews/definitions"
  api_version = "v1.0"
  
  body = {
    displayName             = "Test create"
    descriptionForAdmins    = "New scheduled access review"
    descriptionForReviewers = "If you have any questions, contact jerry@yourdomain.com"
    
    scope = {
      "@odata.type" = "#microsoft.graph.accessReviewQueryScope"
      query         = "/groups/${azuread_group.group.object_id}/transitiveMembers"
      queryType     = "MicrosoftGraph"
    }
    
    reviewers = [
      {
        query     = "/users/${azuread_user.reviewer_user.object_id}"
        queryType = "MicrosoftGraph"
      }
    ]
    
    settings = {
      mailNotificationsEnabled         = true
      reminderNotificationsEnabled     = true
      justificationRequiredOnApproval  = true
      defaultDecisionEnabled           = false
      defaultDecision                  = "None"
      instanceDurationInDays           = 1
      recommendationsEnabled           = true
      
      recurrence = {
        pattern = {
          type     = "weekly"
          interval = 1
        }
        range = {
          type      = "noEnd"
          startDate = "2025-08-16T20:02:30.667Z"
        }
      }
    }
  }
}