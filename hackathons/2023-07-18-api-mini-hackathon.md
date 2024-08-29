# API Minihackathon 2023 @ GONICUS

## Where

GONICUS GmbH
Möhnestraße 55
59755 Arnsberg

[Hotel Recommendation](https://all.accor.com/hotel/7963/index.de.shtml?utm_campaign=seo+maps&utm_medium=seo+maps&utm_source=google+Maps)

Meetingpoint:
* Our conference room will be on the 5th floor of the Moehneturm. Reachable through the Ibis Hotel Lobby
* If you are in the hotel lobby and need directions you can contact @o-otte via matrix, either the Matrix Room for the event, i.e. below, or @o-otte:matrix.im

## When

2023/07/18

1000 CEST - Arrival, settling in, coffee

1200 - Lunch (Pizza in multiple flavors)

1800 CEST - finished - Dinner reservation at [R-Cafe](https://r-cafe.de/standorte/arnsberg)

## Who

### In Presence

- @fkr
- @o-otte
- @artificial-intelligence
- @joshmue
- @master-caster
- @PSwatchmen
- @joshuai96
- @reqa
- @garloff

### Remote

- @janiskemper (MIA)
- @jschoone
- @matofeder
- @chess-knight
- @fdobrovolny

## Matrix-Room

https://matrix.to/#/#scs-api-minihackathon:matrix.org

## Jitsi Room

https://conf.scs.koeln:8443/SCS-Tech

## Miro Board

https://miro.com/app/board/uXjVM1ItlyM=/?share_link_id=121490820613

## Topics and outline

The main goals of the Sovereign Cloud Stack is to build a basis for Cloud Infrastructure with certifiable standards, Openness and Transparency, Sustainability, and the ability to federate between clouds. To reach those goals, more and more features and standards are being built and implemented for and in the SCS project. The work is done in multiple teams for the Container Layer which is the main standard, the IaaS layer which is the optional standard, the operational tooling and the Identity and Access Management and all those development branches are intertwined. To maintain openness, maintainability, and robustness, clear interfaces in forms of APIs are needed. On the second SCS Hackathon in Nuremberg we discussed that all components should interact via certifiable and standardized APIs. This will ensure that components can be swapped out as long as the SCS standards are being followed.
  
Furthermore, a clear and easy to use User Experience (UX) is of utmost importance as this will pull customers to the SCS clouds. In modern clouds, deploying resources should be easy, fast, and reproducible. Often clouds offer tooling to deploy resources in a declarative way. A standardized customer facing API is needed for this as it unifies the many APIs used in a SCS cloud and offers a simple interface for the end user. The customer will be also able to utilize the same API to deploy resources to different SCS clouds in the same way, with the same tooling. Regarding the tooling, the centralized SCS API can be leveraged to build a powerful tool set like an SCS CLI, a Terraform Provider, or other.

The topics we should discuss for this are:
- General ideas on having a central API for everything
- Same API for internal management (e.g. as interface between Container Layer and IaaS) and customers (scs k8s create.., scs vm create ...)?
- How to build the API? RESTful API, utilizing Kubernetes API?
- Where to start with the implementation?

[See joshmue's pitch going into a particular direction, already](https://scs.sovereignit.de/nextcloud/s/tqD9WtAma4HedLs)

## Various links and foo

- https://github.com/kcp-dev/kcp
- https://kubernetes.io/docs/concepts/security/multi-tenancy/
- [gardener multi tenancy issue](https://github.com/gardener/gardener/issues/29)
- [Validation from API Requests in k8s](https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/)

## User stories

CSP customer centric user stories:

- I (as a CSP customer) want to get a `kubeconfig` in order to access the central API (securely)
    - using exec auth plugin that does OAuth2 Device Auth Flow
    - https://miro.com/app/board/uXjVM1ItlyM=/?moveToWidget=3458764559677576242&cot=10
- I (as a CSP customer) want to `kubectl apply` a Kubernetes Cluster and get back a working `kubeconfig` (that enables me to talk to the created cluster)
- I (as a CSP customer) want to `kubectl apply` an IdP identity federation to my (customer owned) IAM
    - https://miro.com/app/board/uXjVM1ItlyM=/?moveToWidget=3458764559677575967&cot=10
    - Alternative/separate userstory / requirement of Wavecon & OSISM: Setup Keystone LDAP Federation

CSP centric user stories:

- I (as a CSP) want to configure controllers to be able to talk to backing services (like OpenStack or keycloak) on behalf of the customer.
- I (as a CSP) want to provision an IdP Realm/Organization for a new customer and give the customer credentials of a customer dedicated administrative account (which the customer may later on use for self-servicing in the IdP)
- I (as a CSP) want to be able to onboard a customer to the central API (ideally but not necessarily using `kubectl`)
    - Includes provisioning of OpenStack application credentials which can be used by ClusterAPI controllers afterwards

## Steps

1. Inspect how Gardener builds multi-tenant control planes
2. Setup a shared Kubernetes with best-effort multi-tenancy for MVP with shared central API service
3. Review security implications
    - Not having the ability to schedule pods does help a lot already
    - What else do we need to do? RBAC, Policy controllers, ... ?
4. Use Central API to create workload cluster (connect to Cluster-API) -- shortcut the existing bootstrap process with per-user management cluster ...
5. Chose a second type of service to connect to (e.g. IAM, IaaS, Metering, ...)


## Action Items

- @fkr to include this topic in invitation to Lean SCS Operator Coffee (@joshmue to attend)
- @artificial-intelligence to give a quick report in this weeks Community Call
- SIG to be founded, chaired by @joshmue and @o-otte
    - Putting the user stories into github and assigning owners
- @artifical-intelligence to persist minutes to github
