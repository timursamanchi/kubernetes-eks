import boto3
from kubernetes import client, config
import os
import time

CLUSTER_NAME = "quote-app-eks"
REGION = "eu-west-2"
NAMESPACE = "quoteapp"

def check_eks_cluster():
    eks = boto3.client("eks", region_name=REGION)
    cluster = eks.describe_cluster(name=CLUSTER_NAME)["cluster"]
    status = cluster["status"]
    endpoint = cluster["endpoint"]
    print(f"[EKS] Cluster status: {status}")
    print(f"[EKS] API Endpoint: {endpoint}")
    return status == "ACTIVE"

def setup_kubeconfig():
    os.system(f"aws eks update-kubeconfig --name {CLUSTER_NAME} --region {REGION}")
    config.load_kube_config()

def check_nodes():
    v1 = client.CoreV1Api()
    nodes = v1.list_node()
    ready_nodes = [n.metadata.name for n in nodes.items if any(
        c.type == "Ready" and c.status == "True" for c in n.status.conditions)]
    print(f"[K8s] Nodes Ready: {len(ready_nodes)}")
    for n in ready_nodes:
        print(f"  ➤ {n}")
    return len(ready_nodes) > 0

def check_coredns():
    v1 = client.CoreV1Api()
    pods = v1.list_namespaced_pod("kube-system")
    coredns = [p for p in pods.items if "coredns" in p.metadata.name and p.status.phase == "Running"]
    print(f"[K8s] CoreDNS pods running: {len(coredns)}")
    return len(coredns) >= 1

def check_services(namespace):
    v1 = client.CoreV1Api()
    try:
        services = v1.list_namespaced_service(namespace=namespace).items
        if not services:
            print(f"[K8s] No services found in namespace '{namespace}'")
            return False
        print(f"[K8s] Services in '{namespace}':")
        for svc in services:
            svc_type = svc.spec.type
            external_ip = (
                svc.status.load_balancer.ingress[0].hostname
                if svc.status.load_balancer and svc.status.load_balancer.ingress
                else "N/A"
            )
            print(f"  ➤ {svc.metadata.name} [{svc_type}] — External IP: {external_ip}")
        return True
    except client.exceptions.ApiException as e:
        print(f"[Error] {e}")
        return False

if __name__ == "__main__":
    print("🚦 Running EKS Cluster Healthcheck...\n")

    if not check_eks_cluster():
        print("❌ Cluster is not in ACTIVE state.")
        exit(1)

    setup_kubeconfig()
    time.sleep(2)

    all_good = True
    all_good &= check_nodes()
    all_good &= check_coredns()
    all_good &= check_services(NAMESPACE)

    print("\n✅ Cluster Healthcheck:", "PASS" if all_good else "FAIL")

