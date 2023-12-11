# 20231211 - Quo Vadis Keycloak Deployment

## Participants

- @fkr
- @berendt
- @reqa
- @scoopex
- @garloff
- @joshmue (since 10:35)

## Expected outcome of the meeting

At the end of the meeting, we know what to tackle how in order to have an up-to-date keycloak on the k8s powered runtime.


## Quick re-cap of current status

- @berendt gives a quick review of the current status and how it evolved until today
    - Move away from ansible roles as only mechanism to provide services at management/infra layer. Enable k8s interface instead. For keycloak and possibly further services that are not integral part of OSISM.
    - k3s on mgmt layer has been shipped with R5, no services on it yet (but has been tested by throwing manifests at it)
    - Recommendations whether to use deployment yamls or helm or flux (or ArgoCD) do not yet exist
    - We should not wait for it, just move ahead pragmatically -- use what is existing (helm? e.g. codecentric chart, bigger question may be database) -- see below
    - Double-check with Team Container
    - Create testbed variant with k3s only (not requiring ceph, openstack)?
    - Future option (past R6): keycloak could also be pushed to an external k8s (which might even enable operator identities to be managed in keycloak)
    - R6 priorities and actions:
        * Moving keycloak to k3s (use helm for now, use flux/Argo for it later) (all)
        * create testbed with only k3s (for faster development/CI cycles) (@berendt)
        * move k3s from manager node to control node*s* (@berendt)
        * document purpose, properties and access to k8s API (@berendt)
        * use keycloak 23 container (@reqa)
        * integration and preconfiguration (@reqa)
        * integration tests (@reqa)
    - Database: codecentric chart does not create HA database
        * cloud-native pg operator based approach ... (maybe longer-term) -- see below
    - Open questions:
        * integration into OSISM install workflow
            * where does helm get deployed?
        * missing infrastructure? DNS, persistent volumes, loadbalancer
        * database
        * migration
            * Is it even needed? (Probably not, no production use of current keycloak setup)
            * Otherwise: Database dump imports tend to work well
- SCS now registry has [Keycloak 23.0.x](https://registry.scs.community/harbor/projects/22/repositories/scs-keycloak/artifacts-tab)

## To be continued

- We're going to continue the discussion on monday - 2023-12-18 at 10:05 CET

## Ideas for discussion:
 
* Application:
  * Codecentric Helm Chart: https://github.com/codecentric/helm-charts/tree/master/charts/keycloakx
  * Aspects
    * TLS between Ingress and Quarkus
    * One domain per realm or one domain with many realms?
    * Kubeping for JGroups HA?
    * Configure cache owners
    * Infinispan password / encryption?
    * Admin Events Cleanup
    * Customize X-Forwared-For for DDOS Protection
    * Disable features
    * Mail Setup
    * Identity Brokering for Master Realm?
    * Process for updates?
    * Delete realms and their contents?
    * How to provision the Standard Realm Setup
      * Identity Mappers?
      * Standard Setup for Idendity Brokering (Documentation)
      * Customize Auth Flows
      * Password Recovery Settings
      * Configure OIDC Clients
      * 2FA Setup
    * Monitoring:
      * Prometheus Exporter
      * Monitor Token Refresh Errors
      * Login behavior
* Database:
  * Per operator, a 3 node cluster : https://cloudnative-pg.io/
    * DB upgrades without downtime
    * Cross-site replication for backup purposes
    * Database backups@