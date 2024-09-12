# Central API Prototype

## What we have

* Many ideas collected
* MVP from https://github.com/SovereignCloudStack/central-api/
    * https://github.com/SovereignCloudStack/central-api/blob/main/poc-setup.md
* Knowledge about Crossplane
    * https://docs.crossplane.io/v1.15/software/install/


## What we want to achieve

- [x] Deploy Central API MVP to vanilla Kubernetes Cluster
- [x] Install Crossplane and composites
- [x] Create an OpenStack resource within resource namespace api.scs.community and evaluate that it was successfully created
- [x] Enable external users to create Crossplane resources to create OpenStack resources
    - [ ] Create users with kubeconfigs instead of service account tokens
- [x] Extend the functionality for KaaS (in this case Cluster Stacks)
    - [x] Try workflow from end user to created resource in workload cluster (e.g. namespace, pod)
    - [ ] We build new composite for api.scs.community with Cluster Stack connection
    - [ ] How do we fetch the workload kubeconfig after Cluster creation? Do we really want to use it? 
        - [ ] Evaluate implementation of OIDC directly, exclusive usage of OIDC in crossplane-created cluster stacks workload clusters 

### Checklist 

- [x] Mixing upbound.io and crossplane.io resources after installing crossplane 0.1.7 and upgrading to 0.3.0 - are there conflicts?
    * Yes, upbound.io is replaced by crossplane.io, resources overlap
    * **Do not mix 0.1.7 with 0.3.0**
- [ ] Why is gen.py script slow?
- [ ] gen.py: Handle resources placed in multiple API domains (compute. vs. networking.)
    - [ ] Create a specific whitelist of resources we want to use in Central API
- [ ] Evalute use-cases for compositions that abstract multiple backend resources into one frontend resource
    * Example: gen.py now mirrors all available resources. A customer needs to create a KeyPair and InstanceV2. In the future only one: VMInstance with SSH key in spec


### Starting points for provider config

#### Crossplane Kubernetes Provider

```
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-kubernetes
spec:
  package: xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.13.0
```

#### Kubeconfig as Secret for ProviderConfig

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: cluster-config
  namespace: crossplane-system
data:
  kubeconfig: ...    # replace with base64 of the cluster-stacks management cluster
---
apiVersion: kubernetes.crossplane.io/v1alpha1
kind: ProviderConfig
metadata:
  name: kubernetes-provider
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: cluster-config
      key: kubeconfig
```

#### Create a simple resource

```yaml
---
apiVersion: kubernetes.crossplane.io/v1alpha2
kind: Object
metadata:
  name: hello-world-namespace
spec:
  forProvider:
    manifest:
      apiVersion: v1
      kind: Namespace
      metadata:
        # name in manifest is optional and defaults to Object name
        # name: some-other-name
        labels:
          foo: "bar"
  providerConfigRef:
    name: kubernetes-provider
```

## Hackathon


## Links

- Crossplane Openstack Provider API: https://marketplace.upbound.io/providers/crossplane-contrib/provider-openstack/v0.3.0
- Crossplane K8s Provider API: https://marketplace.upbound.io/providers/crossplane-contrib/provider-kubernetes/v0.13.0
- Crossplane K8s Provider Docs: https://github.com/crossplane-contrib/provider-kubernetes/blob/main/docs/enhanced-provider-k8s.md


## Problems

### `gen.py` is slow or works a lot

The `gen.py` script crawls all Crossplane OpenStack APIs and converts them into `.api.scs.community` composites. 

* Copying all objects is slow and increases load on the API server, though not all resources are needed
* There's a conflict of resources with the same name from different API versions, so that only one survives the "merge"

We will need to introduce an allowlist to the resources we want to use.

### Using one KinD cluster to connect to the API running in another KinD cluster

This fails because KinD utilizes `127.0.0.1` as the k8s API endpoints in the kubeconfigs. When the other API needs to be reachable from inside one KinD cluster, the internal pod IP (podman, docker) can be used. 

It can be found by running `ip` from inside the cluster, e.g. 

### Error `spec.clusterName`

When a `Cluster` is created in an existing namespace in the Cluster Stacks mgmt cluster, beside another, existing Cluster, the error appears:
![](https://input.scs.community/uploads/96e2c289-a216-4463-9e1c-a18f9c3c9021.png)

