# Identity-Federation, SCS Identity Managment and Permission Managment
---

## General aspects

- Releated/adressed stories:
    - As a CSP operator, I would like to manage the keycloak realm configuration lifecycle in an automated way 
        - create new realms with standardized configurations
        - onboard users for a particular realm
        - execute configuration changes for all tenants
        - delaunch realms
    - As an SCS user, I would like to use my company's identity management to access my SCS environments (using OIDC). 
        - Perform identity brokering whith popular identity providers (i.e. Microsoft Entra/OIDC, ???)
            - [Entra](https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview) : admin@msazureadtest256bit.onmicrosoft.com /  Iheeyaiyu2Hu
        - Allow customers to configure Identity Brokering in self-service
        - Write documentation for users
- Participans: Who joined the session?
    - @frosty-geek
    - @maliblatt
    - @scoopex
    - @PSwatchmen
    - @belgeron 
    - @janhorstmann
    - @garloff


## Managing Authorizations

- As an SCS user, I would like to use my company's identity management to my SCS environments (using OIDC). 
    - only selected claims should be mapped to the particular user (from a data protection view and performance view) in Keycloak
    - you can have multiple identidty providers to a realm (admin staff of csp, different corporate sources)
    - the customer is capable to manage the idp settings by his own
- We are using dedicated oidc-clients on realm level to authenticate 
- There is a 1:1 mapping between keystone domains and keycloak realms
- Mapping on customer identity managment system
    - Users are mapped to groups in the external idendity managment systems
    - Role mappings on customer idp are irrelevant for SCS Keycloak  
- Roles for projects are mapped to the scs groups in SCS keycloak by customer cloud administrators
    - role assignments are cloud specific, no need to define it centrally
    - groups and their members can be reused with different clouds with different role-definitions (the group describes the role/position of the user)
    - the team which is responsible to the particular cloud, understands and manages the role assignments
      (a central identity management team can not understand the consequences of role changes )

## An overview diagram

You can edit the diagram at https://app.diagrams.net/.
(the svg-file embeds the draw.io sourccode)

![](https://input.scs.community/uploads/8052ba06-ab26-40e2-b44a-ff4574dd540a.svg)


### Possible implementation steps:

- create a realm template and create realm automatically for new domains
- custom authentication step: External IDPs adds groups with the name prefix `scs-` to the JWT used for identity brokering
    - Keycloak automatically creates groups which do not already exist in SCS keycloak
    - user is mapped exactly to the listed groups
      (unlisted groups without the `scs-local-` prefix are not removed)
- claim Mapper: 
    - Maps roles in the JWT created for service provider access
    - probably possible with the keycloak default implementation
- roles are consumed by keystone by realms added to the JWT claim
    - roles provided in the JWT are used by keystone
    - can be tested by creating a static claim mapping

### Random summary from Kurt

*   Each SCS Cloud (region) comes with an SCS keycloak
*   Customers have a keystone domain / keycloak realm that they control
*   Can federate out from SCS keycloak to customer IdP (SCS keycloak then becomes ID Broker) or manage users directly there (SCS keycloak = IdP)
*   Disallow admin roles and global realm for external IdPs (except if specially marked for admin-IdP at CSP)
    -  Always confine federated identities to the realm/domain that they belong to
*   Role assignments are always managed in SCS keycloak (role = user/group has manager/member/reader role in project UUID)
    -   project UUIDs are cloud-specific, thus should not end up in customer IdP
    -   discussion: we could alternatively enforce unique project names per domain end then allow names, potentially making them applicable to more than one cloud
*   Group memberships (for `scs-` groups) managed in customer IdP
    -    Clear out additional groups in SCS keycloak (except `scs-local-` groups, opt-out possible, disallowing `scs-local` groups)
*   Option (opt-in) to disallow roles outside of groups
*   Design considerations behind this:
    -   group reflecting the organizational properties and task assignments of an employee do belong to the customer
    -   what this means in terms of roles in a specific cluster or OpenStack project is specific to that cloud, so manage it in SCS keycloak
    -   Self-service wanted, allowing onboarded customers (with domain manager assignment) to establish trust to customer IdP



### Hints and References

- Creating the mapping SAML2:
  (https://ivarclemens.nl/using-keycloak-with-openstack/)
- Creating the mapping for OIDC:
  (https://gtema.github.io/posts/keystone-keycloak/part1/)
- Keystone federation:
  https://docs.openstack.org/keystone/latest/admin/federation/introduction.html
  https://docs.openstack.org/keystone/latest/admin/federation/configure_federation.html
- example from testbed: https://github.com/osism/testbed/blob/main/environments/kolla/files/overlays/keystone/federation/oidc/attribute_maps/oidc_attribute_mappingId1.json
- SCS proposed naming scheme: https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0301-v1-naming-conventions.md
- Keycloak home-idp-discovery: https://github.com/SovereignCloudStack/issues/issues/314#issuecomment-1671017941


## Feedback and Discussion 2024-04-22

### Michael: real-world keycloak and keystone limitations
- Multi-domain multi-realm not supported with keystone-keycloak
    - Fix: Use proxy realm and home-idp-discovery
- Groups are not cleaned up by keystone
- Users may need to be in several realms ...
    - See reseller / integration partner scenario below
- master realm grants keycloak admin access, should not be mixed up with admin rights on cloud
    - SCS does not use master realm but OSISM realm
- Limited mapping of role granularity due to course preprovisiond roles in keystone/openstack

### Reseller / Integration partner scenario
- Service partner wants to access several customer environments to provide managed services for customers
    - Service partner does not want to have 13 accounts to serve 13 customers (who have 13 different domains and 13 realms)
- Customer with hierarchy that needs several bills
    - Per project billing resolves simple scenarios
- Administration delegation
    - ?
    - How can an integration partner with one identity get access to many customer environments (without creating a security hole)?
        - Customer that controls his realm in SCS needs to have the ability to invite external people (without onboarding them into your own IdP)


### Cleanup issues in keystone
- Roles do get persisted in keystone database
    - Can not easily be removed
- Better handling via groups
    - These get cleaned up after some time
- Possible approach: Encode all roles in token and just use these
    - Does not work, as users use unscoped tokens (without roles) to request service tokens from keystone (which assigns roles from the database contents)

### User-provisioning
- User only can get roles and groups assigned as soon as she logs in and thus gets known to keystone ("race condition")
    - Bad user experience on first login (empty horizon, ...)
- Workaround?
    - Preconfigure groups for realms
    - Group assignment may or may not have same challenge
    - Wait for these to hit the cloud before the first logins succeeds (may take a few seconds more ...)
        - On the fly vs. preprovisioning

### OpenStack CLI usage
- v3oidcdeviceauthz has been worked on and should work

### artcodix approach
- Inject authorizations directly into keystone
    - Ignore domains ...
    - Own mapper

### TO DO (2024-04-22)
* Describe federation use cases
    * And prioritize them
* Try to realize them conceptually in different implementation designs
* Try to PoC them to compare concept with reality

