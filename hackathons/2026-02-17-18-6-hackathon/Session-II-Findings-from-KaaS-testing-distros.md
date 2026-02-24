# SCS Hackathon Findings from KaaS testing distros

## SCS KaaS Standards in general
- node distribution: regions work differently in OS, control plane nodes will never be distributed across different OS regions
- Unsure if "KaaS" means "automated cluster provisioning" (without a common API)

## SCS KaaS Tests in general
- `sonobuoy` requirement missing ↦ https://github.com/SovereignCloudStack/standards/pull/1094
- `sonobuoy` not installed in Tests image: https://github.com/SovereignCloudStack/standards/pull/1100
- only one test instance can run at the same time against the same cluster due to sonobuoy namespace being fixed as `sonobuoy`
- When runnning the sonobuoy testing with the `plugin.yaml` from [Github](https://github.com/SovereignCloudStack/standards/blob/main/Tests/kaas/kaas-sonobuoy-tests/scs-conformance-sonobuoy-plugin.yaml), the `scs-kaas-conformance:dev` image can not be pulled due to a `403 Forbidden` when not in the Github-Organisation
    ```
    sonobuoy run --sonobuoy-image docker.io/sonobuoy/sonobuoy:v0.57.3 --wait -p ~/sovereigncloudstack/standards/Tests/kaas/kaas-sonobuoy-tests/scs-conformance-sonobuoy-plugin.yaml
    ```

    ```
    ❯ docker run -v /Users/danielgerber/.kube/aurora/admin.conf:/root/kubeconfig.yaml:ro scs-compliance-check -a kubeconfig=/root/kubeconfig.yaml -a subject_root=. -s TAROOK scs-compatible-kaas.yaml
    CRITICAL: Cannot connect to host 192.168.67.65:8888 ssl:default [Connect call failed ('192.168.67.65', 8888)]

    DEBUG: kubeconfig: /root/kubeconfig.yaml
    DEBUG: sonobuoy not in PATH, trying $HOME/.local/bin
    ```
- Correct command to test against current-context cluster in kubeconfig: 
    ```
    ./scs-compliance-check.py -v -a kubeconfig=~/.kube/config -a subject_root=. -s testing -o report.yaml scs-compatible-kaas.yaml
    ```


- Local: Needs python 3.13 to run, 3.14 can't work due to 

## Distributions

### Tarook
- `topology.kubernetes.io/region` label missing on all nodes ↦ FAIL
- k8s 1.33.5 is considered outdated ↦ FAIL
    - [1.34 is supported](https://docs.tarook.cloud/release/v12.0/releasenotes.html#new-features) ↦ we need to update aurora
- Project idea: TaaS - Tarook orchestration controlled via SECA API?

### k0smotron
- `topology.kubernetes.io/region` label missing on control plane nodes ↦ FAIL

### Gardener
- CNCF compliance tests via hydrophone SUCCESS:
Ran 419 of 6735 Specs in 6699.187 seconds
SUCCESS! -- 419 Passed | 0 Failed | 0 Pending | 6316 Skipped
PASS


### Rancher RKE2

- Deploy with `cni: ["cilium"]` or `cni: ["calico"]` (both supported), both with support for NetworkPolicy.