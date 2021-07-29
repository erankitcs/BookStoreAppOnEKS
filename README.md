# BookStore Web Application On AWS EKS
A book store app powered by AWS EKS. Application is designed in microservices fashion running on EKS and integrating with other AWS Services.

## Steps to run locally without build
I have already shared images on Docker Hub which can be directly used to run the application locally.
1. Create 4 DynamoDb tables into your AWS Cloud (development-inventory, development-resources, development-renting, development-clients)  by reffering tf_modules/dynamodb folder.
2. Run Docker compose file named `docker-compose-image.yaml` using command 
```
docker compose -f .\docker-compose-image.yaml up

```
3. Open the URL on `http://localhost:80`

## Steps to run locally with build
1. Create 4 DynamoDb tables into your AWS Cloud (development-inventory, development-resources, development-renting, development-clients)  by reffering tf_modules/dynamodb folder.
2. Run Docker compose file named `docker-compose.yaml` using command. It will take some time to build and start the containers.
```
docker compose up

```
3. Open the URL on `http://localhost:80`

## Steps to Deploy into AWS Cloud
1. AWS CLI setup with Admin Role.
2. Generate Code Commit Authentication from IAM.
3. Run create.sh to create infrastructure and setup Kubernetes Cluster.
4. Add RBAC for Code Build Jobs using below commands.
```
A. kubectl get -n kube-system configmap/aws-auth -o yaml
//Copy output and create YAML file and update it with each build job role.
- rolearn: <ROLE ARN>
      username: build-<APP NAME>
      groups:
      - system:masters
B. kubectl apply -f .\auth-config.yaml
```
5. Rerun Deployment stage of each CI/CD Pipeline.
6. Go to infrastructure/k8s-tooling/central-ingress and update your own HOSTED ZONE and run
```
./create.sh development
```
7. Verify the Application using the URL.  https://bookstore.dev.`UR-HOSTED-ZONE`
8. Go to each Pipeline and confirm to deploy the application into production environment.
9. Go to infrastructure/k8s-tooling/central-ingress and update your own HOSTED ZONE and run
```
./create.sh prod
```
10. Access prodcution application via https://bookstore.`UR-HOSTED-ZONE`