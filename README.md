# Lab 3 — hello-app on Kubernetes with Terraform

**Name:** Acharya S Aniruddha Raghupathi
**Roll number:** 261100680005

## Part 1: first `terraform plan`

The initial Terraform plan created the Kubernetes namespace, deployment, and service.

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

## Part 1: `terraform output -raw url`

```text
http://localhost:8080
```

## Part 2: plan for the v1 → v2 image change

The deployment image was changed from `v1` to `v2`.

```text
image = "shripada/hello-app:v1" -> "shripada/hello-app:v2"

Plan: 0 to add, 1 to change, 0 to destroy.
```

## Part 3: plan that found the drift after `kubectl scale`

The deployment was manually scaled to 5 replicas using `kubectl scale`. Terraform detected the difference between the actual 5 replicas and the configured 3 replicas.

```text
replicas = "5" -> "3"

Plan: 0 to add, 1 to change, 0 to destroy.
```

## Part 4: `kubectl get svc -A` showing dev and prod

```text
NAMESPACE     NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)
default       kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP
dev           hello-app    NodePort    10.96.64.109   <none>        8080:30340/TCP
kube-system   kube-dns     ClusterIP   10.96.0.10     <none>        53/UDP,53/TCP,9153/TCP
prod          hello-app    NodePort    10.96.34.81    <none>        8090:31940/TCP
```

## Break it: the error after deleting `terraform.tfstate`

After deleting the Terraform state file, Terraform no longer knew that the Kubernetes resources already existed. Running `terraform apply` therefore attempted to create the namespace again and failed because the namespace already existed.

```text
Error creating namespace ... namespaces "dev" already exists
```

The existing namespace was then deleted:

```bash
kubectl delete namespace dev
```

After deleting the namespace, Terraform was able to recreate the resources:

```text
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

## Break it: the wrong selector

The Service selector was intentionally changed from `app=hello-app` to `app=helo-app`. The pods continued running, but the Service had no matching endpoints. This was verified using `kubectl get endpointslice -n dev`, which showed no endpoints. Restoring the selector to `app=hello-app` restored the pod endpoints.

## Screenshot

The browser screenshot is saved as `screenshot.png` in the repository root.
