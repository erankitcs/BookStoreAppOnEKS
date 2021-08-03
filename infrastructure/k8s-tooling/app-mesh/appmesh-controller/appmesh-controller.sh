helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "https://github.com/aws/eks-charts/stable/appmesh-controller/crds?ref=master"

export AWS_REGION=us-west-2

helm upgrade -i appmesh-controller eks/appmesh-controller \
    --namespace appmesh-system \
    --set region=$AWS_REGION \
    --set serviceAccount.create=false \
    --set serviceAccount.name=bookstore-app-mesh-service-account \
    --set log.level=debug \
    --set tracing.enabled=true \
    --set tracing.provider=x-ray