$namespace=$args[0]
if ($null -eq $namespace) {
    $namespace = "development"
    }
helm upgrade --install --namespace $namespace -f values.$namespace.yaml central-ingress-$namespace .