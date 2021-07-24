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
aws eks update-kubeconfig --name $cluster_name --region us-west-2
echo "*** Step- 3 - EKS Tooling-External DNS,Ingress Controller etc ***"
echo "----------Creating Namespaces"
cd $curdir/infrastructure/k8s-tooling/namespaces
kubectl apply -f development.yaml
kubectl apply -f prod.yaml
echo "----------Creating External DNS"
cd $curdir/infrastructure/k8s-tooling/external-dns
kubectl apply -f external-dns.yaml
echo "----------Creating ALB Controller."
cd $curdir/infrastructure/k8s-tooling/alb-controller
template=`cat "alb-ingress-controller.yaml.template" | sed "s/{{CLUSTER_NAME}}/$cluster_name/g"`
echo "$template" | kubectl apply -f -
echo "************** Step- 4 - Creating CI/CD pipeline ****************"
cd $curdir/infrastructure/cicd/terraform
terraform init -input=false
#terraform plan -input=false
terraform apply -input=false -auto-approve
cicd_resource_api_repository_url=$(terraform output -raw cicd_resource_api_repository_url)
cicd_inventory_api_repository_url=$(terraform output -raw cicd_inventory_api_repository_url)
cicd_renting_api_repository_url=$(terraform output -raw cicd_renting_api_repository_url)
cicd_clients_api_repository_url=$(terraform output -raw cicd_clients_api_repository_url)
cicd_front_end_repository_url=$(terraform output -raw cicd_front_end_repository_url)
echo "************** Step- 5 - Pushing code into Code Commits ****************"
cd $curdir/resource-api
git init
git remote add origin $cicd_resource_api_repository_url
git add .
git commit -m "resource api"
git push -u origin master
cd $curdir/inventory-api
git init
git remote add origin $cicd_inventory_api_repository_url
git add .
git commit -m "Inventory api"
git push -u origin master
cd $curdir/renting-api
git init
git remote add origin $cicd_renting_api_repository_url
git add .
git commit -m "renting api"
git push -u origin master
cd $curdir/clients-api
git init
git remote add origin $cicd_clients_api_repository_url
git add .
git commit -m "clients api"
git push -u origin master
cd $curdir/front-end
git init
git remote add origin $cicd_front_end_repository_url
git add .
git commit -m "Front End"
git push -u origin master
echo "Codes have been pushed successfully."
echo "Starting Bookstore Application deployment completed successfully."