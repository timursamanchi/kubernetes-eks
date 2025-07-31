# kubernetes-eks
deploying a multi node kubernetes cluster using EKS and managed by terraform

```
aws eks update-kubeconfig --region eu-west-2 --name quote-app-eks
kubectl get nodes
```

## That command updated ~/.kube/config and set your current context to point to your quote-app-eks cluster.
```
aws eks update-kubeconfig --name quote-app-eks --region eu-west-2

# to check
kubectl config current-context

```

