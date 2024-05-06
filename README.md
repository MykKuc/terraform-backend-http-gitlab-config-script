THE SCRIPT
======

** NOTE! ** This script is only intended for Linux kernel based Operating systems.

This script sets up the environment variables necessary for Terraform backend type "http". This backend uses certain environment variables as indicated by documentation (https://developer.hashicorp.com/terraform/language/settings/backends/http).

The Terraform documentation indicates that environment variables can be used for setting up the variables for Terraform `backend "http" {}` (https://developer.hashicorp.com/terraform/language/settings/backends/http). This is a safer choice compared to using the arguments defined in the docs in the configuration block (because they might get exposed).
GitLab documentation does not provide the method for setting up the needed variables using `TF_HTTP_` method, it provides a way to do this using `terraform init -backend-config="KEY"="VALUE"` method (https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html).

After navigating to the script directory, the script should be run using command ` . ./terraform_backend_http_gitlab_setup.sh` , because otherwise (if only command `./terraform_backend_http_gitlab_setup.sh` is run) the script will execute in the subshell and the environment variables will not be set for the system.