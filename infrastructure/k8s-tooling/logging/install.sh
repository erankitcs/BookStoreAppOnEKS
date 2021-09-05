echo "Creating Logging namespace."
kubectl create namespace logging

# We need to retrieve the Fluent Bit Role ARN
export FLUENTBIT_ROLE="FLUENT_BIT_ROLE_ARN_HERE"

# Get the Elasticsearch Endpoint
export ES_ENDPOINT="ES_ENDPOINT_HERE"

export ES_DOMAIN_USER="bookstore"

export ES_DOMAIN_PASSWORD="ES_DOMAIN_PASSWORD_HERE"

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
