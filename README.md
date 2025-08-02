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

## ✅ Final Routing Map
Request	Goes To
```
curl http://localhost:80	NGINX Ingress → quote-frontend
curl http://localhost:80/quote	NGINX Ingress → quote-backend
curl http://localhost:8080/quote	Direct → quote-backend
```

## create a tunnel (recommended) or do a port-forward
For Minikube tunnel
```
alias mk-tunnel-start="nohup sudo minikube tunnel > /dev/null 2>&1 & echo \$! > minikube.tunnel.pid"
alias mk-tunnel-stop="sudo kill \$(cat minikube.tunnel.pid) && rm minikube.tunnel.pid"

alias mk-kill-all='ps aux | grep -E "minikube tunnel|kubectl port-forward|ssh -o UserKnownHostsFile" | grep -v grep | awk "{print \$2}" | xargs sudo kill -9'

```
For Port-Forward
### 🔹 1. Port-forward the backend directly to 8080 (API access)- backend:
```
kubectl port-forward -n quote-app svc/quote-backend 8080:8080
```

### 🔹 2. Port-forward Ingress separately to 80 (frontend) - sudo reqiured for port 80:

```
sudo kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 80:80
```

### tip: for detached mode -d
```
alias pf-backend-start="kubectl port-forward -n quote-app svc/quote-backend 8080:8080 > /dev/null 2>&1 & echo \$! > backend.portforward.pid"
alias pf-backend-stop="kill \$(cat backend.portforward.pid) && rm backend.portforward.pid"

# run pf-backend-start and then alias pf-backend-stop


alias pf-frontend-start="nohup sudo kubectl port-forward -n quote-app svc/quote-frontend 80:80 > /dev/null 2>&1 & echo \$! > frontend.portforward.pid"
alias pf-frontend-stop="sudo kill \$(cat frontend.portforward.pid) && rm frontend.portforward.pid"

# run pf-frontend-start and then alias pf-frontend-stop
```

### to check if ingresss-nginx is running as loadbalancer
```
kubectl get svc -n ingress-nginx

# or more details
kubectl get svc ingress-nginx-controller -n ingress-nginx -o wide

```

### rollout a new container definition
```
kubectl rollout restart deployment quote-frontend -n quote-app
```