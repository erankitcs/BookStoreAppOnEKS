echo "Installing Metrics Server."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Verifying if Metrics Server is up and running."
kubectl get apiservice v1beta1.metrics.k8s.io -o json | jq '.status'


