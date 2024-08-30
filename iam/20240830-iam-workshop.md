# IAM Workshop 2024-08-30
11:05 -- 12:55 and 14:04 -- 15:25 in https://conf.scs.koeln:8443/SCS-Tech

## Prep 2024-08-23, 14:15 CEST
@JuanPTM, @gtema, @garloff

### Goals for 2024-08-30

#### Morning
* Re-review high goals and use cases that we have defined in previous workshops
    * Which of these have we achieved?
        * With what conditions / limitations?
    * Which ones not?
        * Why?
* Review implementation details 
    * e.g. Identity Provider, Identity Broker
    * Connection to services (OpenStack, Kubernetes)
        * Limitations, needed work, ...
* Create Documentation for R7
    * What works with what limitations?
    * What does not yet work?
    * What will not work soon?

#### Afternoon
* Re-review archtectural choices
    * What do need to do differently?
* Re-review implementation choices
    * Where does keycloak get deployed?
        * k3s not suitable for keycloak with customer access
        * 2ndary workload cluster for user-facing keycloak?
        * API Gateway?
    * Also ensure Day 2 operations for the IAM component
* Create Path past R7
    * Things we may be able to improve in the remaining 3mo
    * Things we can start and expect to live on
    * Things that would be nice but we can't see anyone doing the work
* Need real usage in test environment (at least)
    * SCS2 (gxscs2) at PlusServer
* *One* central document that describes the vision, architecture, and *some* of the choices and considerations

### Preparation for 2024-08-30
* Collect all documents (esp. use cases, goals, ADRs, ...) (AI @JuanPTM, @garloff)
    * Complete them (describe step-wise processes)
        * e.g. Onboarding a new customer
        * Self-Service User and Authorization Management
        * Login and Interaction with the service
            * E.g. Federated users may use only AppCreds?
            * Prohibition of local users for federated domains?
            * Maybe not all details need to be fixed now, but we need to identify the questions, so we see the limitations towards the users
* Read and understand and prepare to describe/summarize (high-level)
* Apptmt is open (of course), but who should be invited specifically?
    * CSPs
        * PlusServer (@frosty-geek or someone he designates)
        * WaveCon (Jeff?)
        * artcodix (Christian?)
    * @scoopex (vacation)
    * @joshuamuehlfort

#### Document collection
* Etherpad from Arvid + JuanPTM: https://input.scs.community/rGfAlCvSS-WYHB3bjY8ggA?both#
* IAM Mini Workshop (2022-10): https://github.com/SovereignCloudStack/minutes/blob/main/ops-iam/20221011-workshop.md
* Hackathon #1 (Cologne) federation notes: https://github.com/SovereignCloudStack/minutes/blob/main/hackathons/2022-11-22-scs-hackathon-cologne/federation-notes.md
* Federation diagrams: https://github.com/SovereignCloudStack/standards/tree/main/Drafts/IAM-federation
* Mini-Workshop Bremen: https://input.scs.community/2023-scs-iam-minihackathon#Brainstorming-Notes
* ADR on using keycloak: https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0300-v1-requirements-for-sso-identity-federation.md
* Moving keycloak to k3s: https://github.com/SovereignCloudStack/minutes/blob/main/iam/20231211-keycloak-kubernetes.md
* Hackathon #4 Arnsberg https://input.scs.community/Hy0HqULMTGeeVIcy0vmBgA# and IAM specific notes: https://input.scs.community/C6OKMb4xQQuqnHC6axv08g#
* Federation via OIDC: https://github.com/SovereignCloudStack/docs/blob/main/contributor-docs/operations/iam/openstack-federation-via-oidc.md
* Diagram OIDC login via proxy realm setup: https://drive.google.com/file/d/1CR-HliOXUXz5fsQwaoF8NU5WfpYbfxpg/view?pli=1

## Workshop

@gtema
@reqa
@juanptm
@michaelbayr
@frosty-geek
@o-otte (afternoon)

### Update from @gtema
* Setting up keycloak in CiaB
    * 1:1 mapping keycloak realm to openstack realm
    * All configured IdPs visible on horizon login
        * home-idp-discovery not configured, documentation missing?
        * Limitation of home-idp-discovery: eMail (domain) could only map to one IdP
        * Several identities required to access several domains in one cloud

### Discussion on usefulness of a public identity provider
* One identity for many public clouds considered useful (and many domains in one cloud)
* New use case ...

### Separation of concerns
* IdP/ID Broker => User authentication, Groups, Group membership
* Platform (keystone) => Authorizations (Roles, role mappings, ...)
* Authorizations in keystone in face of federation:
    - Trouble is that not-yet-known users can not get roles assigned normally
    - keystone driver to do callbacks to keycloak (VexxHost)
    - list users triggers callbacks as well ...
    - user deletion: on access
* Timeline (e.g. user deletion)
    * Authentication to keystone: Token, valid for hours
        * Enough for talking to services (APIs)

### Federation goals - use cases
Trying to sumarize prior work

#### IaaS
* When a new customer gets onboarded, a customer IT manager will get one domain in an SCS IaaS with domain manager capabilities
    * Terminology: We'll call this customer IT manager Domain-Manager here, as we have modeled the OpenStack domain-manager role to match her needs
    * Terminology: Local = inside the used cloud, remote = at the customer location (e.g. a corporate directory) or in some other cloud
    * Domain Manager can create and delete[1] projects inside the OpenStack domain (within quota limits)
        * [1] deletion may be inconvenient in requiring a project to be fully empty to avoid orphans before allowing deletion; an approach to have recursive project resource deletion upon removal of a project would be preferable but is outside of the scope of the federation work
    * Domain Manager can create users, groups and assign roles (authorizations) to those users and groups within the domain (or projects within the domain)
        * Stating the obvious: admin capabilities or authorizations to anything outside of the domain must never be possible for security reasons. (This is better checked at more than one place.)
    * Domain manager can delegate user authentication to a remote IdP - federation
        * This is obviously a per-domain federation relationship under domain-manager (=customer!) control, nothing global
            * The trust decision must be the Domain Manager's (customer's!) decision -- this is important to avoid bill disputes etc.
        * Ideally, establishing trust and setting up the federation = delegating user management to a remote IdP is a self-service operation
        * Federation must at least support OpenID Connect (OIDC); supporting SAML as well is desirable
    * In a federated user management setup, users, groups and group membership should be managed on the remote IdP
        * A logical view that a user gets the ability to work on something by being added to a group is typically managed in a corporate directory by people that don't need to know specifics of technical resources in clouds that are in use
    * The translation of group membership into authorizations to services within projects should be done locally (in the ID Broker that belongs to the cloud or directly in keystone)
        * Setting this up requires some skills from the Domain-Manager, good documentation would be highly desirable
    * The remote IdP may not be freely configurable; the ID Broker thus must allow for some level of mapping of attributes from the users/groups to local capabilities
        * Ideally, this also allows for a broad filtering, like "only ever look at users that belong to these groups (e.g. GithubOrg=SCS) / that have this attribute (e.g. AccessCloudXYZClaim=True) set"
            * A requirement to efficiently handle e.g. social logins from e.g. github and only allowing people that belong to a certain github org
    * An SCS cloud must also be able to serve as (OIDC) ID Provider for other SCS clouds
        * This needs to be technically possible out of the box
        * Whether we force SCS CSPs to exposed this capability is up for discussion
        * The service level (availability) of this feature could become critical and subvert a resilient multi-SCS-cloud setup -- we may need some disclaimers
    * Domain-Manager may want to disallow non-federated users (except possibly the domain-manager herself) via configuration (opt-in)

Considerations from prior conversations
* We have worked with the assumption that an OpenStack Domain has a 1:1 relationship with a keycloak realm
* If API access for federated users only works via application credentials, this may be acceptable
    * In that case, care must be taken that offboarded users will be removed from having access within a reasonable amount of time (max 1d, ideally seconds)
    * For performance and resilience reasons, synchronous validation with remote IdP is obviously not an option
    * A requirement to have at least one Domain-Manager per domain as a local user is acceptable (and probably desirable for resilience)
* Authorizations are expressed in group X has manager/member/reader access to project Y (or service Z in project Y in case people really want to do more finegrained things)
* Admin access to clouds is outside of the scope of this discussion -- operators operating lots of regions may want federation for admins; similar concepts as for user federation may apply, but mixing this in here has the potential to cause security headache -- own ID broker and provider instances with different configuration, filtering, ... would be needed anyhow.

#### KaaS
* For self-service cluster creation, member access to an IaaS project will be required and sufficient
* For managed KaaS: A specific authorization for the user(group) could be required to manage (create / upgrade / scale / delete) clusters
* Once a cluster exists, cluster-admin and admin access should be controlled by group memberships from the remote identities, so users can be given admin/cluster-admin access to cluster by adding them to groups on a remote IdP. A mapping of remote IdP group membership to local meaning ("has admin privileges on cluster XYZ") should happen locally (local keycloak or some setting in the k8s control plane)
* More finegrained authorizations within a cluster are possible as self-service config by the cluster-admins and should be documented -- these again should be controllable by remote IdP group membership mapped locally to a local meaning


### Discussions
* Use cases of a corporate directory (well-controlled private IdP) and using a public IdP ("github") may be very very different
* Users from several IdPs can not be in one real/domain?
    * Can one realm federate out to several IdPs
* Self-service capabilities
    * OpenStack Domains: Domain-manager roles
    * Keycloak: Realm-admin capabilities can be handed out (by design)
        * Includig setting up federation?
        * Double check, e.g. secret handling in OIDC
        * Role "manage ID providers", realm-scoped, exists in keycloak
* Cross-realm usage
    * *If* you have access to more than one domain with your identity, somehow you have to chose it
* Users can have rights in several domains (and could do `openstack domain list`)
    * But it's seldomly used this way, there may be dragon
    * Drop down for domains in horizon
        * Would require users to no longer belong into one domain
* Logging out when beloging to several domains
    * Switching vs log out
* Selecting your identity provider, redirecting to IdP, avoiding to have too many selection screens for users

### CNDS setup - public cloud provider view
* All users part of one domain (but without rights)
    * Separate system that adds roles to users in projects
    * Limitations: number of roles
    * Domains are used behind the scene
* Currently not prepared to connect your own remote IdPs
    * Future work (AWS and Azure have it)
* The well-known IdPs are all connected ("social login")
    * Requires roles/rights/authorizations to be assigned individually
    * Inconvenient if you want to reassign employees to different company project

### Corporate directory connections
* https://docs.aws.amazon.com/de_de/singlesignon/latest/userguide/gs-ad.html
* UCS does it for Azure
* Their integration of private IdPs is by creating a two-way synchronization for AD
    * Likewise github enterprise
    * Resolves interfacing issues and avoids availability and performance issues

### Two ways on login
* Social login
* username => home-idp-discovery

### Strawman
* Cloud-Provider does preconfigure global logins
* Tenant Root Account can have additional IdPs configured for their domain/realm

**Use case A: Global login** 
- e.g. A consultant who needs access to several tenants
- e.g. someone who simply wants to access a cloud without creating a new account
- Use Global/Shared/Social Login
    ~~- One possible variant: Run an SCS IdP~~
- Individual rights needs to be granted by tenant root account
    - Indirection via group membership handled at CSP level (not trusting group membership from global IdP, but local group memberships)
        - Long-term option to consume and map IdP attributes

**Use case B: Employees from corporate directories**
- Tenant Root Account has the ability to connect their private/corporate IdP (ideally via self-service)
- Rights management by group membership in corporate directory
- Rights attached to roles assigned to groups locally on the cloud by Tenant Root Account

Differences:
* Users belonging to domain (B) vs. global users (A)
* Group memberships from IdP (B) vs. local group memberships (A)

Use case B may require a dedicated login page or home-idp-discovery

### SSID approach
- Publish all authorizations along with your ID
    - Not implemented yet anywhere
    - Requires detailed knowledge of the way you consume resources
        - Not going to happen

### AFTERNOON PLAN
* Defocus user experience (unless it is fundamentally unresolvable) for now
* MVP scoping (both use cases vs. one?)
    * Build demonstrator (based on testbed/CiaB)
    * MVP implementation for case B -- see @gtema's update
    * Feature set discussion ...
    * PS needs: Both use cases in one testbed (and later one prod region)
        * Otherwise stay with local users and using their corporate directory

#### Limitations
* keycloak creates local identities on first login from external IdP
    * Only afterwards, roles can be assigned

### CNDS Proposal
* Internal, abstracted user management system
    * Authentication can be delegated to external IdP (SSO)
    * All the business logic in there
* Abstracted shell user identity, decoupled from what IdPs provide or OpenStack uses
    * Mapping shell user -> OpenStack (also to Kubernetes, SaaS services, ...)
    * Adaptor IdPs -> shell users
* Advantage: Independent from limitations and opinionatedness of user management

Discussion:
- Can't we use OIDC identities?
- Should we use OpenStack identities?
    - How would that work with KaaS?

Current Setup:
- Keystone uses proxy realm in keycloak

KG Proposal:
- Roles are assigned locally to users/groups always
    - Local groups only for Social Login realm
    - Remote group membership for private realm (corporate dir)
- Tenant root account is a local account


```
                                             /-- Global realms -- Public IdPs
OpenStack keystone -> Keycloak proxy realm <
                                             \-- Private realm -- Corp dir
```

Tenant root user does manage:
- keystone (domain-manager rights)
    - assign roles to users
    - assign roles to keycloak groups (coming from private realm)
    - create local groups (to put users into from global realm)
    - assign users to local groups
    - assign roles to local groups
- private realm setup
    - create federation to corp dir

Additional rules:
- global realms do not provide (trustable) groups

### Preprovisioning users
- Required to assign roles normally
- Can be worked around using a keystone driver (like the one from vexxhost)

### Proxy realm
- All users visible there ...

### Trouble
- domain-manager role in OpenStack can only see users from his own domain
- thus adding social users does not work with the current definition of domain-manager
- Federated user login: user needs to belong to a domain
- But social login user does not belong to a single domain
- "Special/global domain" needed for social users?

Decisions:
* Both use cases B and A?
    * Need to have a path forward to allow for A
* Continue to iteratively improve or be open to reimplement more ... outside of keystone, keycloak limitations
    * Can not be decided right now, need to explore both options for a bit more:
        * Can use case A be added to B (which is mostly implemented -- some caveats remaining), overcoming the fundamental challenges (list users, ...)? -> @gtema, @JuanPTM
        * Is it realistic to have our own user management outside of keycloak/keystone -> @garloff w/ @michaelbayr, @gtema

