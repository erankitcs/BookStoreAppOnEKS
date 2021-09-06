echo "Creating Logging namespace."
kubectl create namespace logging
### These variables are being exported into their infrastructure deployment script in Terraform
### bookstore_create_infra.sh
# ES_KIBANA_ENDPOINT, ES_ENDPOINT, ES_DOMAIN_USER, ES_DOMAIN_PASSWORD,FLUENTBIT_ROLE

# Update the Elasticsearch internal database
curl -sS -u "${ES_DOMAIN_USER}:${ES_DOMAIN_PASSWORD}" \
    -X PATCH \
    https://${ES_ENDPOINT}/_opendistro/_security/api/rolesmapping/all_access?pretty \
    -H 'Content-Type: application/json' \
    -d'
[
  {
    "op": "add", "path": "/backend_roles", "value": ["'${FLUENTBIT_ROLE}'"]
  }
]
'

cat fluentbit_template.yaml | envsubst > fluentbit.yaml

kubectl apply -f fluentbit.yaml

kubectl --namespace=logging get pods

echo "Kibana URL: https://${ES_ENDPOINT}/_plugin/kibana/
Kibana user: ${ES_DOMAIN_USER}
Kibana password: ${ES_DOMAIN_PASSWORD}"
