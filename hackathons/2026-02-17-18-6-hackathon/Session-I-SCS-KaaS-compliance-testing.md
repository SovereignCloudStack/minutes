# Session I - SCS KaaS compliance testing

Room: *Weave*

## Participantst

- Marvin (@depressiveRobot)
- martin [email](mailto:martin.mai@uni-bamberg.de), [matrix](https://matrix.to/#/@martin.mai:academiccloud.de)
- Janis Kemper
- Lukas (@cpt-kernel-afk)
- Freerk (@fzakfeld)
- Mahdieh

## Links

- SCS-compatible KaaS: https://docs.scs.community/standards/scs-compatible-kaas
- KaaS compliance test suite: https://github.com/SovereignCloudStack/standards/tree/main/Tests
- Plugins: https://github.com/SovereignCloudStack/standards/tree/main/Tests/kaas/plugin

## Minutes

- open discussion about the meaning of "certified SCS-compatible KaaS": do we want to certify a platform or a cluster
  - open question: how do we define platform?
- missing documentation on how to feed the compliance monitor for KaaS at https://docs.scs.community/standards/certification/pipeline
- testing of storage in order to run and migrate databases in k8s (to be compatible and portable)
  - for example: PostgreSQL with CloudNativePG (https://cloudnative-pg.io/)
- Martin contributes a use case of creating a backup of a workload in one cluster and restore it in another cluster

### standards vs. test suite

#### CNCF Kubernetes conformance

> In order to have the same conditions for all providers, we need our own SCS standard which defines a fixed list of mandatory tests (CNCF) that must be fulfilled.

- own standard which defines how to run the tests and a list of mandatory tests
  - standard exists already as [scs-0200](https://docs.scs.community/standards/kaas/scs-0200), but still draft status and outdated by now
  - to run the CNCF conformance test, it is necessary to start sonobuoy with specific flags, see https://github.com/SovereignCloudStack/standards/blob/1bebabc9282601f1bba591b5f861488f135e09c2/Tests/scs-compatible-kaas.yaml#L14
  - see also https://github.com/SovereignCloudStack/standards/pull/1092
  - analogues to https://github.com/SovereignCloudStack/standards/pull/1047

#### [scs-0210](https://docs.scs.community/standards/scs-0210-v2-k8s-version-policy/)

- https://docs.scs.community/standards/scs-0210-v2-k8s-version-policy/#:~:text=Kubernetes%20versions%20MUST%20be%20supported%20as%20long%20as%20the%20official%20sources%20support%20them
  - cannot be tested automatically
  - should be noted in https://docs.scs.community/standards/scs-0210-w1-k8s-version-policy-implementation-testing

#### [scs-0214](https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/)

- https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/#:~:text=The%20control%20plane%20nodes%20MUST%20be%20distributed%20over%20multiple%20physical%20machines%2E
  - not tested automatically
  - manual check how this is assured
  - issue: https://github.com/SovereignCloudStack/standards/issues/1104
- https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/#:~:text=At%20least%20one%20control%20plane%20instance%20MUST%20be%20run%20in%20each%20%22failure%20zone%22%20used%20for%20the%20cluster%2C%20more%20instances%20per%20%22failure%20zone%22%20are%20possible%20to%20provide%20fault%2Dtolerance%20inside%20a%20zone
  - what does this mean?
  - it seems as if this standard doesn't make sense, because the control planes shouldn't be necessarily dependent on the worker nodes. If a user creates the worker nodes in different failure zones / regions, then this shouldn't mean necessarily that the control planes also need to be in these zones. 
- https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/#:~:text=providers%20MUST%20annotate%20their%20K8s%20nodes%20with%20the%20labels
  - checking label `node-role.kubernetes.io/control-plane` is not meaningful for non-kubeadm clusters
    - see https://github.com/SovereignCloudStack/standards/blob/3d109eafa111a516fd836f91b8a6724753b2aca4/Tests/kaas/k8s-node-distribution/k8s_node_distribution_check.py#L180
    - https://kubernetes.io/docs/reference/labels-annotations-taints/#node-role-kubernetes-io-control-plane-taint
- improve logging to avoid confusion/be more explicit
  - [standards#1105](https://github.com/SovereignCloudStack/standards/pull/1105)
- there is a standard talking about node distribution (https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution) and there is a test for node distribution (https://github.com/SovereignCloudStack/standards/blob/3d109eafa111a516fd836f91b8a6724753b2aca4/Tests/kaas/k8s-node-distribution/k8s_node_distribution_check.py). However, the standard says things about the distribution in different failure zones that don't seem to make a lot of sense, and in the test it is written down in a way and tested in a way that do not seem to comply with the standard. In the test it is written that we need to have the control planes in differnet failure zones, while in the standard it is written that the control planes must be in each failure zone used by the cluster (i.e. the workers). 
