# Session VII - Discussion round on SCS-KaaS certification readiness

Room: *Cilium*

## Participants

- Marvin Frommhold (@depressiveRobot)
- Felix Kronlage-Dammers (@fkr)
- Dennis Wittling (@dentling)
- Freerk-Ole Zakfeld (@fzakfeld)
- Benedikt Haug (@benedikt-haug)
- Janis Kemper (@janiskemper)
- Torsten Hallmann (@thallma)

## Minutes

- https://docs.scs.community/standards/scs-compatible-kaas
- two kinds of certification
  - certification of a KaaS platform according to [scs-0004](https://docs.scs.community/standards/scs-0004-v1-achieving-certification)
  - certification as integrator according to [scs-0007](https://docs.scs.community/standards/scs-0007-v1-certification-integrators)
- if multiple KaaS configurations are offered, certification is only for a specific configuration (aka subject)
  - should be stated more explicitly
  - how do we show this on the certificate and badge?
  - how do we ensure that CSPs only advertise SCS-certified for that specific configuration?

### CNCF Kubernetes conformance

- own standard which defines how to run the tests and a list of mandatory tests
  - standard exists already as [scs-0200](https://docs.scs.community/standards/kaas/scs-0200), but still draft status and outdated by now
  - to run the CNCF conformance test, it is necessary to start sonobuoy with specific flags, see https://github.com/SovereignCloudStack/standards/blob/1bebabc9282601f1bba591b5f861488f135e09c2/Tests/scs-compatible-kaas.yaml#L14
  - see also https://github.com/SovereignCloudStack/standards/pull/1092
  - analogues to https://github.com/SovereignCloudStack/standards/pull/1047
  - test exclusions should be possible due to custom setups according to customer needs
    - however, exclusions must be justified
    - exclusions will be documented and then apply equally to everyone

### [scs-0210](https://docs.scs.community/standards/scs-0210-v2-k8s-version-policy/)

- current test checks if cluster is newest version only
- recommendation to not support older versions should be dropped
  - see https://docs.scs.community/standards/scs-0210-v2-k8s-version-policy/#:~:text=It%20is%20RECOMMENDED%20to%20not%20support%20versions%20after%20this%20period%20in%20order%20to%20not%20encourage%20usage%20of%20out%2Dof%2Ddate%20versions
  - there are use cases where providers explicitly support older versions as added value for their customers
- existing issue about dropping the requirement to mandatory support patch versions within two weeks: https://github.com/SovereignCloudStack/standards/issues/1098
- harmonize CVE handling
  - PR https://github.com/SovereignCloudStack/standards/pull/1099
  - align time periods along C5 criteria catalogue

### [scs-0214](https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/)

- https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/#:~:text=The%20control%20plane%20nodes%20MUST%20be%20distributed%20over%20multiple%20physical%20machines%2E
  - cannot be tested automatically
  - manual check how this is assured
    - default setup provided by CSPs must follow standard
    - prove that customers are actively informed about this
    - link to documentation
  - issue: https://github.com/SovereignCloudStack/standards/issues/1104
- https://docs.scs.community/standards/scs-0214-v2-k8s-node-distribution/#:~:text=At%20least%20one%20control%20plane%20instance%20MUST%20be%20run%20in%20each%20%22failure%20zone%22%20used%20for%20the%20cluster%2C
  - can be dropped, as this makes no sense in practice and cannot be fulfilled in every setup
  - downgrading to recommendation makes also no sense, as it is already recommended in Kubernetes best-practices
- "failure zone" not well defined in context of Kubernetes
  - "failure zone" == "availability zone"
  - align with IaaS standard
  - add that availability zone is well-defined in SCS IaaS and means xyz
- the node distribution check that we have in our test suite is kubeadm-based and only checks the recommendation from Kubernetes that we should have the control planes on different availability / failure zones. We should consider to drop this test
- if we implement all of the adjustments above to the standard, nothing can be checked automatically anymore
  - so the test should only output a warning that it appears as if the Kubernetes recommendations have not been implemented

### [scs-0219](https://docs.scs.community/standards/scs-0219-v1-kaas-networking/)

- https://docs.scs.community/standards/scs-0219-v1-kaas-networking/#:~:text=CSPs%20MUST%20provide%20a%20network%20plugin%20that%20fully%20supports%20NetworkPolicy%20resources%20in%20the%20API%20version%20networking%2Ek8s%2Eio%2Fv1%2E
  - currently not tested automatically
  - open issue: check if this is really covered by CNCF
