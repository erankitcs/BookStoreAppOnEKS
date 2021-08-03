#!/bin/sh

echo "************** Creating CI/CD pipeline ****************"
curdir=$(pwd)
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