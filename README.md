# Terraform Jenkins

_The infastructure for an AWS jenkins servers_

This is the complete infrastructure for a Jenkins pipeline using AWS as a provider and S3 as a backend.

## Technology Versions

- **Terraform version:** 1.3.4

## Things to note

- Applying these changes to will incur costs to your AWS account.
- This setup assumes that you have a EC2 launch template configured. (EC2 Launch template confugration can be found in EC2 module README)
- This setup assumes you have your own domain configured in AWS Route 53.
- This setup assumes that you are deploying to US East 2.
- This setup also assumes that you do not want to destroy your volumes. (So that Jenkins state can be saved and persisted)
- All of these assumptions can be edited or changed.
- All areas of code that say `replace-me`.....need replace/renamed.
- You must create a production.tfvars file that has ALL of the example variables configured.
- When your jenkins server is up and running you will need to SSH into your instance to get the master password. Here is the command for that:

```
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## How to make changes

- Be sure that you have changed directories into the correct directory. For example if you would like to
  make changes to brain you will need to `cd tf/jenkins` .
- Before you make changes be sure you are in the correct workspace. For example `terraform workspace select production`
- When a you are applying changes make sure that you use the specific an env file. For example `terraform apply -var-file="production.tfvars"`

## Helpful Commands

```
# how to apply
$ terraform apply

# if you are applying a specific environment
# all you need to do is reference the vars file
# EXAMPLE: $ terraform apply -var-file="production.tfvars"
$ terraform apply -var-file="<your-environment-variable-file.tfvars"

# --------


# how to destroy
$ terraform destroy

# ------

# workspaces
#
#
# how to apply a new workspace
$ terraform workspace new <your-workspace-name>

# you can select a workspave by using
$ terraform workspace select <your-workspace-name>

# list all of that have been made
$ terraform workspace list

# show the current workspace
$ terraform workspace show
```
