# set the subscription
export ARM_SUBSCRIPTION_ID="4f126fa1-4ecb-4b04-86ef-e26043dd2c81"

# set the application / environment
export TF_VAR_application_name="devops"
export TF_VAR_environment_name="prod"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-prod"
export BACKEND_STORAGE_ACCOUNT="st4u9atidkv9"
export BACKEND_CONTAINER_NAME="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name 

# run terraform
terraform init  \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"
   
terraform $*

rm -rf .terraform
