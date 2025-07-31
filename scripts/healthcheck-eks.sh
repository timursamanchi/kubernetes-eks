#!/bin/bash

CLUSTER_NAME="quote-app-eks"
REGION="eu-west-2"
NAMESPACE="quoteapp"
echo ""
echo "🚦 Running EKS Cluster Healthcheck..."
echo ""

# Update kubeconfig
echo "🔧 Updating kubeconfig..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION" > /dev/null

# Check nodes
echo "🧠 Checking node status..."
kubectl get nodes -o wide || { echo "❌ Failed to list nodes"; exit 1; }

# Check CoreDNS
echo "📦 Checking CoreDNS pods..."
coredns_status=$(kubectl get pods -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[*].status.phase}')
if [[ "$coredns_status" == *"Running"* ]]; then
  echo "✅ CoreDNS is running"
else
  echo "❌ CoreDNS is not running properly"
fi

# Check services in app namespace
echo "🌐 Checking services in namespace '$NAMESPACE'..."
kubectl get svc -n "$NAMESPACE" || echo "⚠️  No services found in namespace $NAMESPACE"

# Optional: get external IPs
echo "🌍 Checking for LoadBalancer IPs..."
kubectl get svc -n "$NAMESPACE" -o jsonpath="{range .items[*]}{.metadata.name}:{.status.loadBalancer.ingress[*].hostname}{'\n'}{end}" | grep -v '^:$' || echo "ℹ️  No external IPs found"

echo "✅ Healthcheck complete."

