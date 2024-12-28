#!/bin/bash
aws eks --region eu-west-3 update-kubeconfig --name weather-cluster

kubectl apply -f ./service-account.yaml

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=weather-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=eu-west-3 \
  --set vpcId=vpc-06588392b24372777






# #   helm uninstall -n kube-system aws-load-balancer-controller aws-load-balancer-controller