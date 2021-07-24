# BookStore Web Application On AWS EKS
A book store app powered by AWS EKS. Application is designed in microservices fashion running on EKS and integrating with other AWS Services.

## Steps:
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
7. Verify the Application using the URL.  https://bookstore.dev.<HOSTED ZONE>
8. Go to each Pipeline and confirm to deploy the application into production environment.
9. Go to infrastructure/k8s-tooling/central-ingress and update your own HOSTED ZONE and run
```
./create.sh prod
```
10. Access prodcution application via https://bookstore.<HOSTED ZONE>