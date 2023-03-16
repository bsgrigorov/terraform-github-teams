# Terraform Github Provider User and Teams management
If you want to manage user and teams in github through terraform, this is the repo for you.

This repo makes use of the Github Terraform Provider https://registry.terraform.io/providers/integrations/github/latest/docs 

Things you will need to setup:
- Github Org
- Github App - create it, install it in the org, create a private key
- Terraform cloud or local state

# Github App
1. Add your github org name to vars.tfvars
2. Create a Github App at https://github.com/organizations/{org}/settings/apps/new
   1. Give https://app.terraform.io as Homepage if using terraform cloud
   2. uncheck webhook
   3. select Org permissions > Members > Read and Write
   4. Only this account and apply
3. Take note of the App ID and add it to the vars.tfvars file
4. Go to private keys and generate a private key and store it in [github-app-private-key.pem](github-app-private-key.pem) file
5. Go to Install app and install it in your org
6. Take a note of the Installtion ID in the URL https://github.com/organizations/{org}/settings/installations/{THIS_ID} and put it in vars.tfvars

# Terraform
1. Add your org name and workspace id to [providers.tf](providers.tf)
2. Run 
```
terraform init
terraform validate
terraform plan --var-file vars.tfvars
terraform apply --var-file vars.tfvars
```

Note: the users that you add to your org will need to accept the invite before they appear in any teams.
