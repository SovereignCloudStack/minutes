# OpenDesk as an SCS KaaS reference/benchmark app

see also / related: 
* https://input.scs.community/oHXq_eAATHyVsxkJwQEM0Q# 
* https://input.scs.community/NwtLWp6tSFWCUdGXFB5Z6g#
* startpage of hackathon 2026
    * https://input.scs.community/NQ_hwTLkTmKXwbJlz3T-mw#


---

Topics identified (not necessarily directly related to OpenDesk):
- RWX storage class required for NextCloud scaling
    - Manila is problematic
- RWO: why is SCS-0211 not in cert scope?
    - v2 not finalized
- s3 is very much in use - overlap with IaaS scope
    - db backups
    - OpenDesk needs it
    - split it off from SCS-0123 and include it in KaaS scope?
- idea: binding(?) expectations what features/annotations customer apps need to have to work "properly" in a SCS KaaS cluster, require CSPs to communicate them?
    - podDisruptionBudgets
    - health/readiness probes
- secret management as a service is something customers ask for
    - vault, openBao, gpg...
    - barbica has very low adoption
    - flux is a solution closer to K8s
    - what about https://apeirora.eu/
    - minimal standard language "There MUST be an HTTP API that returns a secret"
    - someone(TM) needs to look at all the solutions out there and distill a minimal common ground
- K8s user management/access control
    - customers tend to deploy keycloak etc if there is no provided solution
    - rancher is popular because it integrates this, has LDAP integration
    - ban static, long-lived admin kubeconfigs?
    - OIDC as mandatory interface
- network level encryption/MTLS
    - relevant for zero trust
    - customers start to request it
- ingress & loadbalancing
    - customers don't want to deal with it, "just make it work"
    - industry standard to supply load balancing for Services
    - many possible solutions: Octavia, custom LBaaS, native OVN, MetalLB
    - low hanging fruit
    - "CSPs MUST offer a managed, networking.k8s.io/v1-compliant Ingress controller and a default IngressClass resource for this controller."
    - "The ingress controller Service MUST have the type LoadBalancer."
    - "A Service of type LoadBalancer MUST automatically receive an IP address outside the internal K8s cluster network. That address MUST be reachable from the Internet."
    - e2e conformance test by GETting a generated string from a minimal web server deployment
    - collecting feedback from kube3 community
        - https://pad.gwdg.de/7CB8ZNkFSSSPuh5zuRAs8w#