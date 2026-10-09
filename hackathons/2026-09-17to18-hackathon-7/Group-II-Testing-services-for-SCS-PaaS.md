---
tags: scs,hackathon,hackathon7,2026
title: SCS Hackathon 7 - Group II Testing services for SCS PaaS
---

# SCS Hackathon 7 - Group II: Testing services for SCS PaaS

Room: 05.132 "Testing Trash"

## Participants

- @toothstone
- @gerbsen
- David

## Minutes

### LLM DevOps Seminar als AI-Usecase

Traditioneller Stack: Uni-RZ mit SLURM, täglicher vLLM-Job
↦ Zukunft: "AI-Factories" auf K8s-Basis

Lösung 1. Durchlauf: K8s (Gardener) bei PlusServer, GPU/HPC weiter über SLURM (Nutzung GPU-Produkt nicht möglich) ↦ Wie stellt man auch GPU in K8s bereit? 1 Mega-Cluster für alle Studis, 1 Cluster/Studi (Kosten!), ...

### K8s application requirements matrix

**Haven+** The [following table](https://havenplus.commonground.nl/docs/reference-implementations/providers/overview) shows the compliance status for each provider across all Haven+ requirements and additional operational capabilities.


| Requirement/Standard   | OpenDesk | [CIVITAS/CORE](https://docs.core.civitasconnect.digital/docs/Deployment/Cluster-Setup/Remote/Cloud-Setup/#prerequisites) | kserve | [Haven+](https://havenplus.commonground.nl/docs/reference-implementations/providers/overview/#compliance-matrix) |
| ------------- | -------- | ------------ | ------ | --- |
| RWO / [default StCl - SCS-0211](https://docs.scs.community/standards/kaas/scs-0211) |    x     |  x    | | x |
| RWX           |  x       | | | x |
| local storage |          | x | | |
| s3 (SCS-0123?) | x        | | | x |
| [LoadBalancer svc - PR !648](https://github.com/SovereignCloudStack/standards/pull/648) | x     | x | x | x |
| Ingress Ctrlr |    x     | x | ? |
| Gateway Ctrlr | ? | x | ? |
| Secrets aaS   | | | x |
| Autoscaling   | | | | x |
| Ext. DNS comp | | | | x |
| [HA ctrl plane - SCS-0214](https://docs.scs.community/standards/kaas/scs-0214) | | | | x |

### AI Use Case

* How to request ([IaaS flavor scheme for GPUs](https://docs.scs.community/standards/scs-0100-v3-flavor-naming#optional-gpu-support))
    * GPU model
    * GPU capabilities (CUDA compute capability version)
        * minimum capabilities (e.g. no NVIDIA "legacy" GPUs)
    * GPU memory

## Referenzen

- [How to schedule GPUs in K8s](https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/)

> For inspiration: something similar was discussed during Hackathon #6 in Fürth: [K8s features needed for OpenDesk](https://input.scs.community/KaaS-OpenDesk-as-ref-app) [name=Friedrich]
> For further inspiration: we already discussed to make openDesk a reference application for SCS (which would fit neatly into Deutschland-Stack) [#1167](https://github.com/SovereignCloudStack/standards/issues/1167) [name=Daniel]


### Hackathon cluster: getting started

A Kubernetes cluster on Syself Autopilot, with a GPU node for AI workloads.

#### 1. Get access
You need kubectl, and nothing else. If you have not previously installed it, follow the official Install [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) guide for your operating system.

Save the kubeconfig you were given, then:

```
export KUBECONFIG=/path/to/hackathon-kubeconfig.yaml
kubectl get nodes
```

#### 2. What is in the cluster
| Nodes | What they are |
| --- | --- |
| 3 control planes | Managed by Syself, nothing to do there |
| 3 workers | Hetzner Cloud servers, for normal workloads |
| 1 GPU node | Bare metal, NVIDIA GeForce GTX 1080, 8 GB VRAM |

```
kubectl get nodes
```

### 3. Run something on the GPU
Request nvidia.com/gpu: 1 in your container's limits. That is all it takes. The request steers the pod to the GPU node, because no other node advertises that resource.

The baremetal node gpu card has 8 GB of memory, and every pod running on it shares that same 8 GB. Keep your model well inside it, and check what is already running there before you start:

```
kubectl describe node -l autopilot.syself.com/gpu=true | grep -A9 "Allocated resources"
```

To check how to schedule a pod on the GPU node, see [Run GPU workloads](https://syself.com/docs/hetzner/apalla/workloads/specialized/run-gpu-workloads).

### 4. Storage, and the one thing that will catch you out
The StorageClass you pick has to match the node your pod runs on.

| StorageClass | Works on | What it is |
| --- | --- | --- |
| standard (default) | the 3 cloud workers | Hetzner Cloud volumes, attached over the network |
| local-ssd | the GPU node only | about 466 GiB of SSD inside that machine |

The default storageclass does not work on the GPU node. Hetzner Cloud volumes cannot attach to a bare-metal server, so a GPU pod with a standard claim sits in Pending forever. For storage next to the GPU, ask for local-ssd.

kubectl get sc also lists local-nvme and local-hdd. Current baremetal server doesnt have those disks, so a claim on either never binds. Ignore them.

Anything you write to local-ssd lives on that one server, and data is lost incase the server goes down. In production environments, replicate the data to multiple servers for high availability.

Details: Use [Hetzner Cloud volumes](https://syself.com/docs/hetzner/apalla/storage/block/use-hcloud-volumes) and [Set up local NVMe with TopoLVM](https://syself.com/docs/hetzner/apalla/storage/local/local-nvme-with-topolvm), which is already installed here.

### 5. Expose something to the internet
No ingress controller is installed by default. The quickest route is a `LoadBalancer` Service, which provisions a real Hetzner load balancer with a public IP. Try it with nginx:

```
kubectl create deployment lb-test --image=nginx:alpine --replicas=2
kubectl expose deployment lb-test --type=LoadBalancer --port=80
kubectl get svc lb-test -w
```

`EXTERNAL-IP` shows `<pending>` for a second, then fills in with an IPv4 and an IPv6 address. Open `http://<the IPv4 address>` in your browser and you get the nginx welcome page.

Delete the load balancer and the deployment when you are done:

```
kubectl delete svc lb-test
kubectl delete deployment lb-test
```

For testing and learning, exposing any deployment with `--type=LoadBalancer` is the quickest route. In production you would usually run an ingress controller such as [Traefik](https://syself.com/docs/hetzner/apalla/network/expose/install-traefik) instead, so that every app shares one entry point rather than getting a load balancer of its own.

Details: [Service type LoadBalancer](https://syself.com/docs/hetzner/apalla/network/expose/service-type-loadbalancer)

### 6. If something goes wrong

| Symptom | Likely cause |
| --- | --- |
| GPU pod stuck Pending | The card is full, or you asked for more than 1 |
| GPU pod Pending with a volume | A standard PVC on the GPU node. Use local-ssd. See section 4 |
| CUDA out of memory | Another pod is using the same 8 GB. See section 3 |
| nvidia-smi not found | Use a CUDA base image, not a plain one |

```
kubectl describe pod <name>        # scheduling and event detail
kubectl logs <name>
```

### Worth a look
- [Deploy your first app](https://syself.com/docs/hetzner/apalla/getting-started/deploy-your-first-app)
- [Explore your cluster](https://syself.com/docs/hetzner/apalla/getting-started/explore-your-cluster)
- [Resource requests and limits](https://syself.com/docs/hetzner/apalla/workloads/production/resource-requests-and-limits)
- [Deploy with Helm](https://syself.com/docs/hetzner/apalla/workloads/delivery/deploy-with-helm)