terraform-backend-http-gitlab-config-script 
======

**NOTE!** This script is only intended for Linux kernel based Operating systems.

After navigating to the script directory, the script should be run using command ` . ./terraform_backend_http_gitlab_setup.sh` , because otherwise (if only command `./terraform_backend_http_gitlab_setup.sh` is run) the script will execute in the subshell and the environment variables will not be set for the system.

This script sets up the environment variables necessary for Terraform backend type "http". This backend uses certain environment variables as indicated by documentation (https://developer.hashicorp.com/terraform/language/settings/backends/http).

The Terraform documentation indicates that environment variables can be used for setting up the variables for Terraform `backend "http" {}` (https://developer.hashicorp.com/terraform/language/settings/backends/http). This is a safer choice compared to using the arguments defined in the configuration block (because they might get exposed).
GitLab documentation does not provide the method for setting up the needed variables using `TF_HTTP_` method, it provides a way to do this using `terraform init -backend-config="KEY"="VALUE"` (https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html). And Terraform docs themselves do not recommend using `-backend-conf=` , because terraform will include those values in subdirectory `.terraform/` and plan files. GitLab also suggests using env variables as remote data source, but there is a simpler way using this script.

## Terraform State locking

Script allows to choose if user wants Terraform State locking, which prohibits multiple developers to make changes at thew same time while the state is locked.
If State locking is chosen, then user will get multiple other env variables configured.