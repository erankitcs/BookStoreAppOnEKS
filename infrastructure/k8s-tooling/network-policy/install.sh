echo "Network Policy using Calico."

kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.6/calico.yaml

sleep 60

echo " Getting the Deamon set and it should be Available now."

kubectl get daemonset calico-node --namespace=kube-system

echo "Applying default Deny into Developement and Production Namespace."
kubectl apply -n development -f default-deny.yaml
kubectl apply -n prod -f default-deny.yaml

echo " Allow only Nginx (Proxy) to talk to Microservices-APIs"
kubectl apply -n development -f allowProxytoAPI.yaml
kubectl apply -n prod -f allowProxytoAPI.yaml