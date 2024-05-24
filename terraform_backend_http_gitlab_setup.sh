#!/usr/bin/env bash

echo "Starting the execution of the script for setting environment variables for Terraform http backend."

echo "Looping and checking if certain env variables are already set."

terraform_http_backend_env_variables_values=("TF_HTTP_ADDRESS" "TF_HTTP_USERNAME" "TF_HTTP_PASSWORD")

check_tf_http_address_format_correctness() {
    
    ##FIXME Fix this regex.
    if [[ "$1" =~ ^https://gitlab\.com/api/v4/projects/([0-9]+)/terraform/state/([^/\s]+)$ ]];then
        echo "Provided GitLab address is CORRECT !"
        echo "export TF_HTTP_ADDRESS=$1" >> ~/.bashrc
        return 0
    else

        echo "Provided GitLab address is INCORRECT !"
        return 1       
    fi

}

loop_until_correct_tf_http_address_entered() {

    while true ;do
        read -p "Please enter correct format GitLab Terraform HTTP address to store the state. Enter here:" user_entered_th_http_address

        if check_tf_http_address_format_correctness "$user_entered_th_http_address";then
            echo "The format of TF_HTTP_ADDRESS is correct."
            break
        else
            echo "The format of TF_HTTP_ADDRESS is incorrect. Repeating address entry operation."
        fi
    done
}

## Method for the configuration of locking Terraform state so other developer won't start making changes while changes are ngetting applied.
implement_terraform_state_locking_configuration() {
    echo "Adding Environment variables related to Terraform State locking."

    gitlab_lock_unclock_address_ending="/lock"

    echo "!! Setting up LOCK and UNLOCK addresses."
    gitlab_tf_address_env_var=$(printenv TF_HTTP_ADDRESS)

    gitlab_full_lock_unlock_address=$("$gitlab_tf_address_env_var$gitlab_lock_unclock_address_ending")
    echo "Lock and unlock addresses are being set to: $gitlab_full_lock_unlock_address"

    echo "export TF_HTTP_LOCK_ADDRESS=$gitlab_full_lock_unlock_address" >> ~/.bashrc
    echo "export TF_HTTP_UNLOCK_ADDRESS=$gitlab_full_lock_unlock_address" >> ~/.bashrc

    echo "!! Setting up lock and unlock methods !! "
    echo "If environment variables TF_HTTP_LOCK_METHOD and TF_HTTP_UNLOCK_METHOD are already set, then they will be overridden with methods POST and DELETE as indicated by GitLab documentation."
    
    terraform_http_lock_method_env_variable_on_machine=$(printenv TF_HTTP_LOCK_METHOD)
    terraform_http_gitlab_lock_required_method="POST"

    if [ -z "$terraform_http_lock_method_env_variable_on_machine" ] || [ "$terraform_http_lock_method_env_variable_on_machine" != "$terraform_http_gitlab_lock_required_method" ];then

        echo "Environment variable TF_HTTP_LOCK_METHOD is either not set or set with incorrect method. Changing it now !"
        echo "export TF_HTTP_LOCK_METHOD=$terraform_http_gitlab_lock_required_method" >> ~/.bashrc
    else

        echo "Environment variable TF_HTTP_LOCK_METHOD is set correctly."
    fi

    terraform_http_unlock_method_env_variable_on_machine=$(printenv TF_HTTP_UNLOCK_METHOD)
    terraform_http_gitlab_unlock_required_method="DELETE"

    if [ -z "$terraform_http_unlock_method_env_variable_on_machine" ] || [ "$terraform_http_unlock_method_env_variable_on_machine" != "$terraform_http_gitlab_unlock_required_method" ];then

        echo "Environment variable TF_HTTP_UNLOCK_METHOD is either not set or set with incorrect method. Changing it now !"
        echo "export TF_HTTP_UNLOCK_METHOD=$terraform_http_gitlab_unlock_required_method" >> ~/.bashrc 
    else

        echo "Environment variable TF_HTTP_UNLOCK_METHOD is set correctly."
    fi
}

main() {

    for terraform_env_variable in "${terraform_http_backend_env_variables_values[@]}";do

        echo "Doing operations with variable: $terraform_env_variable ."
        retrieved_terraform_http_env_variable=$(printenv "$terraform_env_variable")

        if [ -n "${retrieved_terraform_http_env_variable}" ];then
            echo "The environment variable $terraform_env_variable is already set. "

            ## This is an operation to check the correctness of address field for storring the Terraform state file.
            if [ "$terraform_env_variable" = "TF_HTTP_ADDRESS" ];then
                echo "This is TF_HTTP_ADDRESS env variable. Running operation to check correctness of the address."

                if check_tf_http_address_format_correctness "$retrieved_terraform_http_env_variable";then
                    echo "Env variable TF_HTTP_ADDRESS already exists and is correct."
                else
                    echo "Existing env variable is incorrect. Please enter new one."
                    loop_until_correct_tf_http_address_entered
                fi
            fi 

        else
        
            echo " $terraform_env_variable Is not set yet !!! "

            if [ "$terraform_env_variable" = "TF_HTTP_ADDRESS" ];then
                loop_until_correct_tf_http_address_entered
            else
                echo "Please enter value for Environment variable $terraform_env_variable below:"
                read user_env_variable_input
                echo "User has inputed $user_env_variable_input . "
                echo "export $terraform_env_variable=$user_env_variable_input" >> ~/.bashrc
            fi
        fi

    done

    read -p "Do you wish to apply Terraform State Locking ? If yes, please enter yes:" is_user_wish_to_apply_state_locking

        if [ "$is_user_wish_to_apply_state_locking" == "yes" ];then 
            implement_terraform_state_locking_configuration
        else
            echo "Terraform State locking will NOT be applied."
        fi
}

## Exceute main function.
main