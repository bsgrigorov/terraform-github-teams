provider "github" {
  owner = var.github_organization_name
  app_auth {
    id              = var.github_app_id                  # or `GITHUB_APP_ID`
    installation_id = var.github_app_installation_id     # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = file(var.github_app_pem_file_path) # or `GITHUB_APP_PEM_FILE`
  }
}

terraform {
  cloud {
    organization = "" ### REQUIRED ### 
    workspaces {
      name = "" ### REQUIRED ###
    }
  }

  required_version = ">= 0.13"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
