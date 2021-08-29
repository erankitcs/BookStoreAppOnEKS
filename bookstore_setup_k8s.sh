#!/bin/sh

echo "*** EKS Tooling-External DNS,Ingress Controller etc ***"
echo "----------Creating Namespaces"
curdir=$(pwd)
cd $curdir/infrastructure/k8s-tooling/namespaces
kubectl apply -f development.yaml
kubectl apply -f prod.yaml
kubectl apply -f appmesh-system.yaml
echo "----------Creating External DNS"
cd $curdir/infrastructure/k8s-tooling/external-dns
kubectl apply -f external-dns.yaml
echo "----------Creating ALB Controller."
cd $curdir/infrastructure/k8s-tooling/alb-controller
kubectl apply -f alb-ingress-controller.yaml
echo "----------Creating App Mesh Controller."
cd $curdir/infrastructure/k8s-tooling/app-mesh/appmesh-sa
helm upgrade --install --namespace appmesh-system bookstore-app-mesh .
cd $curdir/infrastructure/k8s-tooling/app-mesh/appmesh-controller
./appmesh-controller.sh
cd $curdir/infrastructure/k8s-tooling/app-mesh/mesh
kubectl apply -f development-mesh.yaml
kubectl apply -f prod-mesh.yaml
echo "----------Creating Metrics Server for HPA and Cluster Autoscaler."
cd $curdir/infrastructure/k8s-tooling/autoscaling-hpa-ca/
./autoscale.sh

echo "----------Creating Prometheus and Graphana for Monitoring and Alerting."
cd $curdir/infrastructure/k8s-tooling/monitoring
./install.sh