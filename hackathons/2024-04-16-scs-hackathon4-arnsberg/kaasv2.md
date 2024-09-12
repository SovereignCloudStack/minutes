---
title: KaaS @ 4th SCS Community Hackathon
---

# ROOM X - KaaS v2 with Cluster Stacks

The KaaS v2 session was mostly about learning ClusterAPI ClusterClass and Cluster Stack basics

## ClusterAPI ClusterClass

To learn how a ClusterClass looks like, we generated the resources with `clusterctl generate cluster` with `CLUSTER_TOPOLOGY=true` which is needed for ClusterClass.
The easiest way to generate this is to use the [CAPI Quickstart](https://cluster-api.sigs.k8s.io/user/quick-start.html)

## Road to Cluster Stacks

https://github.com/SovereignCloudStack/cluster-stackathon

After learning the ClusterClass, we started to build Cluster Stacks with this.
Starting with the folder structure, we created the Helm charts for the clusterclass and the cluster addons.

## Building assets

### Prerequisites
- docker
- git
- go
- kind
- tilt
- yq
- csctl

### Test with Docker Provider

As the ClusterAPI relies on various providers to deploy workload clusters, there's also a [Docker Provider](https://github.com/kubernetes-sigs/cluster-api/blob/main/test/infrastructure/docker/README.md) which is used as a reference implementation for other infrastructure providers and is explicitly not described as production ready.
For our tasks this was perfect for testing the creation of Cluster Stacks.
So we created the [Cluster Stacks `Hackathon` for Docker](https://github.com/SovereignCloudStack/cluster-stackathon/tree/main/providers/docker/hackathon/1-28) validated them with Helm and tested them the Cluster Stack Operator using Tilt.

```
$ export PATH=$PATH:$(go env GOBIN)
$ go install github.com/SovereignCloudStack/csctl@latest
$ git clone https://github.com/SovereignCloudstack/cluster-stackathon
$ git clone https://github.com/SovereignCloudstack/cluster-stack-operator

```
