#!/bin/sh

echo "Starting Bookstore Application Deployment."
curdir=$(pwd)
echo "*********** Step-1 - Creating DynamoDB Tables **************"
echo "----------Clients API DynamoDB"
cd $curdir/clients-api/infra/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve
echo "----------Inventory API DynamoDB"
cd $curdir/inventory-api/infra/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve
echo "----------Renting API DynamoDB"
cd $curdir/renting-api/infra/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve
echo "----------Resource API DynamoDB"
cd $curdir/resource-api/infra/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve

echo "***** Step-2 - VPC,EKS Cluster, IAMs, Certificates  *********"
cd $curdir/infrastructure/eks/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve
cluster_name=$(terraform output -raw cluster_name)
export FLUENTBIT_ROLE=$(terraform output -raw fluentbit_irsa_role)
aws eks update-kubeconfig --name $cluster_name --region us-west-2

echo "***** Step-3 - Elastic Search in AWS  *********"
cd $curdir/infrastructure/elasticsearch/terraform
terraform init -input=false
terraform apply -input=false -auto-approve
export ES_KIBANA_ENDPOINT=$(terraform output -raw es_kibana_endpoint)
export ES_ENDPOINT=$(terraform output -raw es_endpoint)
export ES_DOMAIN_USER=$(terraform output -raw es_user)
export ES_DOMAIN_PASSWORD=$(terraform output -raw es_password)
export AWS_REGION="us-west-2"