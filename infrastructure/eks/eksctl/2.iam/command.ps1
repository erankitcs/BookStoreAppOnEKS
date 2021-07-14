# Plan
eksctl utils associate-iam-oidc-provider --cluster CLUSTERNAMEHERE
#Execute
eksctl utils associate-iam-oidc-provider --cluster CLUSTERNAMEHERE  --approve

## Once Policy is created. Run this for all the APIs
eksctl create iamserviceaccount --name resource-api-iam-service-account --namespace develeopment --cluser CLUSTERNAMEHERE --attach-policy-arn POLICY_ARN_HERE --approve
