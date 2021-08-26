echo "Installing Metrics Server."
##https://github.com/kubernetes-sigs/metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Verifying if Metrics Server is up and running."
kubectl get apiservice v1beta1.metrics.k8s.io -o json | jq '.status'

echo "Installing Cluster Autoscaler."
##https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
kubectl apply -f cluster-autoscaler-autodiscover.yaml

echo "Avoid Node delete for CA Pod itself."
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
echo "You can update Cluster Autoscaler version to match up your cluster version."
echo "HPA and CA are ready."

