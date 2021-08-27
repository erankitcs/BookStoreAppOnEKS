# add prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# add grafana Helm repo
helm repo add grafana https://grafana.github.io/helm-charts

echo "Installing Prometheus."
kubectl create namespace prometheus

helm upgrade prometheus prometheus-community/prometheus --namespace prometheus -f prometheus/alerts.yaml -f prometheus/prometheus.yaml

echo "You can port forward to view the UI - kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090"

echo "Installing Grafana."

kubectl create namespace grafana

helm install grafana grafana/grafana --namespace grafana --values grafana/grafana.yaml

echo "Monitoring Tools setup completed."