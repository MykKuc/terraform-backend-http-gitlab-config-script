#! /bin/bash

echo "Starting the execution of the script for setting environment variables for Terraform http backend."

echo "Looping and checking if certain env variables are already set."

terraform_http_backend_env_variables_values=("TF_HTTP_ADDRESS" "TF_HTTP_USERNAME" "TF_HTTP_PASSWORD")

for terraform_env_variable in "${terraform_http_backend_env_variables_values[@]}"; do
    echo "Doing operations with variable: $terraform_env_variable ."

    retrieved_terraform_http_env_variable=$(printenv "$terraform_env_variable")
    if [ -n "${retrieved_terraform_http_env_variable}" ];then

        echo "The environment variable $terraform_env_variable is already set. "
    else
    
        echo " $terraform_env_variable Is not set yet !!! "
        echo "Please enter value for Environment variable $terraform_env_variable below:"
        read user_env_variable_input
        echo "User has inputed $user_env_variable_input . "
        export "$terraform_env_variable"="$user_env_variable_input"
    fi

done