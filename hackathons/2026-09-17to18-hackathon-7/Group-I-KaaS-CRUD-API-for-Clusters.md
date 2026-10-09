---
tags: scs,hackathon,hackathon7,2026
title: SCS Hackathon 7 - Group I KaaS CRUD API for Clusters
---

# SCS Hackathon 7 - Group I: SCS KaaS - CRUD API for Clusters

Room: 05.018 "Cluster CRUD"

## Participants

- @cwrau
- @tasches
- @fzakfeld
- @depressiveRobot
- @schnatterer

## Minutes

- Providers don't want to offer two "competing" APIs
  - e.g. Gardener Shoot API **plus** Custom SCS API

- Provider specific features
  - e.g. OIDC addon, custom kubelet settings, CNI settings

### Two possibilities

- Full fledged API
  - t8s POC: https://github.com/cwrau/scs-kaas-api
- shim API with discovery / conversion / templating
- (not discussed in depth) service discovery just returns provider-specific interface, like Gardener (see also [@berendt's idea in #1264](https://github.com/SovereignCloudStack/standards/issues/1264#issuecomment-5291453007)) --> From a consumer's point of view this does not offer a lot of benefits 
  - @cwrau: isn't portable betweenn providers / needs big clients that need to grow for new providers
- (not discussed) exising api https://spec.secapi.cloud/docs/api/Extensions/Kubernetes-v1beta1/create-or-update-cluster
  - would need extending, they don't have discovery and no support for provider specific features
  - we would need to decide if we really want all the fluff (tenants, workspaces, unchangeable cluster names, undescribed "sku" (whatever that is?), setting \*CIDRs, volumes for nodes, subnets for nodes, securityGroups for nodes (openstack specific?), taints for nodes (better concepts resource requests + priorityClasses))
  - separate api for cluster creation and nodePool creation; no single curl for creation
  - also of course not under SCS control, if they change we'd need to move as well "forever"

### Discovery service

#### Discovery example

See also [@berendt's idea in #1264](https://github.com/SovereignCloudStack/standards/issues/1264#issuecomment-5291453007)

An example reponse from the discovery service:

```yaml
scs-02XX: v1 # the standard describing the discovery service and payload
conformances: #  non-empty list of supported SCS-compatible KaaS scopes
  - scs-0502-v1
  - scs-0502-v2
endpointUrl: https://example.org/kaas/clusters # TODO kubernetes API server also possible?
regions: # non-empty map of available regions (contains non-empty list of availability zones)
  de-north:
    availabilityZones:
      - az1
      - az2
  de-east:
    availabilityZones:
      - default
versions: # non-empty list of available k8s versions (at least the latest 3 minor versions according to scs-0210-v2)
  - 1.36.4
  - 1.35.8
  - 1.34.11
  # TODO allow to skip patch version (only provide minor, e.g. 1.34)?
nodeTypes: # list of available node types (naming convention based on scs-0100-v3)
  - SCS-2V-4-20s # Client can infer "vcpus": 2, "ram_gb": 4, "disk_gb": 20 (SSD+), name is passed to Create API
  - SCS-1V-4-10
  # TODO Mandatory list of nodes that each provider has to offer like in IaaS?
features: # map of available provider specific non-standardized features (json schema)
  cni: # maybe required description + spec? 
    type: string
    enum:
      - cilium
      - calico
  confidential_computing:
    type: object
    properties:
      enabled:
        type: boolean
# TODO naming constraints (e.g. number of chars, special chars allowed, etc) or "friendly name" and provider use ID in the background (would be difficult to match in Gardener dashboard for example)
```

### Full-fledged API

#### SCS cluster example spec

possibly kubernetes style

```yaml
name: myCluster 🚀🚀🙈
workerGroups:
  - name: cnpg-workers
    size: SCS-1V-4-10
    replicas: 2
    maxReplicas: 4
version: 1.36.4
features:
  cni: cilium
  confidential_computing:
    enabled: true
```

Ideas:
* Design API to look like K8s, providers are open to implement it using a managment cluster or a custom REST API that implements the standard
* Most (all?) fields are optional, providers can decide about default values. Or ship defaults via service discovery
* Can the SECA-Standard be used? See above


### shim API with discovery / conversion / templating

```bash
curl https://example.org/.well-known/scs-compatible-kaas.yaml
```

```yaml
scs:
  version: v2
  cluster:
    endpoint:
      create: 
        url: https://example.org/kaas/create
        defaults:
          cni: calico
        payload: |
            {
                "cloud": "$REGION$",
                "nodePools": {
                    "pool-0": {
                        "flavor": "standard.2.1905",
                        "replicas": 3
                    }
                },
                "version": {
                    "major": 1,
                    "minor": 35,
                    "patch": 5
                },
                {% if cni | default('cilium') == 'cilium' %}
                "cilium": {
                  "subnet": "$SUBNET"
                },
                {% else if cni | default('cilium') == 'calico' %}
                "calico": {
                  "subnet": "$SUBNET"
                },
                
                "confidential_computing": ${FEAT_CONFIDENTIAL_COMPUTING:-false}
            }
      delete: 
        url: https://example.org/kaas/delete
        payload: ""
```

### teuto.net cluster example

```json
{
    "cloud": "bfe2-prod",
    "nodePools": {
        "pool-0": {
            "flavor": "standard.2.1905",
            "replicas": 3
        }
    },
    "version": {
        "major": 1,
        "minor": 35,
        "patch": 5
    }
}
```

### ScaleUp / Gardener Shoot example

```yaml
kind: Shoot
apiVersion: core.gardener.cloud/v1beta1
metadata:
  name: pu2mt66f0d
  namespace: garden-c71493-1
spec:
  provider:
    type: openstack
    infrastructureConfig:
      apiVersion: openstack.provider.extensions.gardener.cloud/v1alpha1
      kind: InfrastructureConfig
      networks:
        workers: 10.250.0.0/16
      floatingPoolName: external
    controlPlaneConfig:
      apiVersion: openstack.provider.extensions.gardener.cloud/v1alpha1
      kind: ControlPlaneConfig
      loadBalancerProvider: amphora
    workers:
      - name: worker-f79yl
        minimum: 1
        maximum: 2
        maxSurge: 1
        machine:
          type: SCS-2V-4-40p
          image:
            name: gardenlinux
            version: 1877.17.0
          architecture: amd64
        zones:
          - az1
        cri:
          name: containerd
  networking:
    nodes: 10.250.0.0/16
    type: calico
  kubernetes:
    version: 1.36.4
  cloudProfile:
    name: occ2
    kind: CloudProfile
  credentialsBindingName: my-openstack-secret
  purpose: evaluation
  region: RegionOne
  maintenance:
    autoUpdate:
      kubernetesVersion: true
      machineImageVersion: true
    timeWindow:
      begin: 000000+0200
      end: 010000+0200
```

### Syself cluster example

TODO @janiskemper

### Thoughts (Out of scope for now)

- Release Channels like static, stable, rapid, etc; [Example: GKE](https://docs.cloud.google.com/kubernetes-engine/docs/concepts/release-channels)
- Prices