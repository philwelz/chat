#!/bin/bash
# Used to bootstrap infrastructure required by Terraform

set -e  # Exit on error
set -o pipefail  # Exit on pipeline failure

# Check for jq installation
if ! command -v jq >/dev/null; then
    echo "Error: jq is not installed."
    exit 1
fi

# Central error handling
error_handler() {
    echo "Error on line $1"
    exit 1
}

trap 'error_handler $LINENO' ERR

# Check and export subscription/tenant if needed
if [[ -z "$subscriptionId" ]]; then
    export subscriptionId=$(az account show --query id -o tsv)
    [[ -n "$subscriptionId" ]] && echo "Subscription exported..." || exit 1
else
    echo "Subscription details are set..."
fi

if [[ -z "$tenantId" ]]; then
    export tenantId=$(az account show --query homeTenantId -o tsv)
    [[ -n "$tenantId" ]] && echo "Tenant exported..." || exit 1
else
    echo "Tenant details are set..."
fi

# Sources variables
if [[ -f ".env" ]]; then
    source .env
else
    # Set env config
    # change values as needed
    name="openai"
    scope="tf"
    location="swedencentral"
    tag="$stage"

    # Resource Group
    rg="rg-$name-$scope"

    # Service Principal
    spName="sp-$name-$scope"

    # Storage Account
    saName="stac0${name}0${scope}"
    saSku="Standard_ZRS"
    scName="blobcont-$name-$scope"

    # GitHub
    ghRepo="philwelz/chat"
fi

# Set subscription
az account set --subscription "$subscriptionId"

# Creates resource group
az group create \
    --name "$rg" \
    --location "$location" \
    --tags env=$tag managedBy="terraform-scaffolding" \
    --subscription $subscriptionId

if test $? -ne 0
then
    echo "Resources group couldn't be created..."
    exit
else
    echo "Resources group created..."
fi

# Create storage account
az storage account create \
    --name "$saName" \
    --resource-group "$rg" \
    --location "$location" \
    --sku "$saSku" \
    --tags env="$tag" managedBy="terraform-scaffolding" \
    --allow-blob-public-access true \
    --min-tls-version TLS1_2

if test $? -ne 0
then
    echo "Storage Account couldn't be created..."
    exit
else
    echo "Storage Account created..."
fi

# Create container
az storage container create \
    --name "$scName" \
    --account-name "$saName" \
    --auth-mode login

if test $? -ne 0
then
    echo "Storage Account container couldn't be created..."
    exit
else
    echo "Storage Account container created..."
fi

# Create managed identity
az identity create \
    --name "mi-$name-$scope" \
    --resource-group "$rg" \
    --location "$location" \
    --tags env="$tag" managedBy="terraform-scaffolding"

if test $? -ne 0
then
    echo "Managed identity couldn't be created..."
    exit
else
    echo "Managed identity created..."
fi

# Get managed identity
managedIdentity=$(az identity list --resource-group $rg --query "[].principalId" -o tsv)

# Update roles
az role assignment create \
    --assignee "$managedIdentity" \
    --scope "/subscriptions/$subscriptionId" \
    --role "Owner"

if test $? -ne 0
then
    echo "Role assignment owner couldn't be created..."
    exit
else
    echo "Role assignment owner created..."
fi

# Get storage account id
storageAccountId=$(az storage account show --name $saName --resource-group $rg --query id -o tsv)

# Update roles
az role assignment create \
    --assignee "$managedIdentity" \
    --scope "$storageAccountId" \
    --role "Storage Blob Data Owner"

if test $? -ne 0
then
    echo "Role assignment Blob Data Owner couldn't be created..."
    exit
else
    echo "Role assignment Blob Data Owner created..."
fi

# create federated credential for branches
az identity federated-credential create \
    --resource-group $rg \
    --identity-name "mi-$name-$scope" \
    --name "fc-github-$name-$scope" \
    --issuer "https://token.actions.githubusercontent.com" \
    --subject "repo:$ghRepo::ref:refs/heads/main"\
    --audiences "api://AzureADTokenExchange"

# create federated credential for environment
az identity federated-credential create \
    --resource-group $rg \
    --identity-name "mi-$name-$scope-pr" \
    --name "fc-github-$name-$scope" \
    --issuer "https://token.actions.githubusercontent.com" \
    --subject "repo:$ghRepo:pull_request"\
    --audiences "api://AzureADTokenExchange"

if test $? -ne 0
then
    echo "federated credential couldn't be created..."
    exit
else
    echo "federated credential created..."
fi

gh secret set ARM_CLIENT_ID --body $(az identity list --resource-group $rg --query "[].clientId" -o tsv) --repo $ghRepo
gh secret set ARM_SUB_ID --body $subscriptionId --repo $ghRepo
gh secret set ARM_TENANT_ID --body $tenantId --repo $ghRepo
gh secret set TF_STATE_RG --body $rg --repo $ghRepo
gh secret set TF_STATE_STAC --body $saName --repo $ghRepo
gh secret set TF_STATE_CONTAINER --body $scName --repo $ghRepo
