# SCS Community Hackathon

Identity Brokering für SCS / Openstack CLI

## Priortized Requirements
1. Identity Brokering
2. Usability
3. MFA

## Approaches
1. Extend keystoneauth project by implementing WebSSO "Authorization Code Flow" in python-requests
2. Extend Keycloak by implementing identity brokering support for Direct Grant flow
3. Avoid the interplay of openstack CLI and OIDC/OAUTH2 (and MFA!) entirely by just documenting how to use WebSSO (Horizon or successor solution) and then recommend generating an application credential and download that to use it for use with openstack CLI.
4. Research into the possibilities of "Oauth 2.0 Device Authorization Grant" for openstack CLI (i.e. keystoneauth)

## Assessment
* Requirement 3 makes approach 1 unattractive, because we would need to re-implement stuff for each MFA method ([v3oidcpassword supports OTP](https://opendev.org/openstack/keystoneauth/commit/d3f26262d1d1e1615cc2019e83449f996955c8ba)] but not fancy things like WebAuthn)
* Keycloak may be unattractive for integration with Keystone/Apache when the requirement is to be able to add/remove customer specific Openstack Domain to Keycloak Realm federations. OTOH see below
* Approach 3 seems like the easy way out, but that would be a better solution than approach 1
* Approach 4 should be investigated deeper, that looks promising and fresh (see below)

## Discussion with @joshmue (leading to approach 4 above)

* Hint 1 by @joshmue: "Oauth 2.0 Device Authorization Grant"
    * https://auth0.com/docs/get-started/authentication-and-authorization-flow/device-authorization-flow
    * Supported by Keycloak: https://github.com/keycloak/keycloak-community/blob/main/design/oauth2-device-authorization-grant.md

* Hint 2 by @joshmue: ory/oathkeeper could help with authorization control for API endpoints

## Discussion Session with Wavecon:
* Reported advantage of Zitadel: A central set of endpoints and the decision, which "Project" (customer) shall be used for authentication, is made based on the DNS domain that which was used to issue the request against.
    * colleteral topic: DNS based discovery of federated domains: denic netID - could be useful to map email address style logins like foo@Customer1.com to customer IdPs via DNS (TXT records)
    * Quote by @jnull: "In case you are lucky and your username is unique, then auth would also work without specifying the target domain"
    * Assessment by @reqa regarding "the greener side" Zitadel: Sure, getting this domain selection done with Keystone/apache config requires, to dive into annoying details of the Apache config and particularly to make use of details of the configuration options of `mod_auth_openidc` and `mod_oauth2`, or even to extend them if required. But I guess there aint no such thing as a free lunch. Maybe Zitadell is the "Pixie Dust", but maybe it's also just a large promise that looks "greener" than the experience wthat we already gained with Keycloak/Keystone integration.
    * Also with Keycloak we can use/define a central "SCS" realm, which selects the specific custoemr relam via  `?kc_idp_hint=<CUSTOMERID>` as passed by Keystone/Apache.
* Discussion about "vaultID"walt.id / SSIs and the question, how to realize role assignment/authorization in this context and what roles we could/should define in a standard way on SCS level. Assessment: The SSI can only deliver the identities, but not the roles. The roles need to be assigned in an IdP (customer?) and mapped to "well defined" SCS roles (like openstack `domain manager` or `project manager`).+1

* Question by @reqa to @jnull (async via chat) regarding the selling point "static set of central endpoints" of Zitadel: "The mental picture I had about the Keycloak/Keystone integration is that we define one central Realm SCS or so in Keycloak that federates/brokers out to (a lot of) customer-specific Realms in the same SCS-Keycloak. The customer-specific Realms allow self service and allows customers to in turn hook up their own external IdP (or even mutiple). -- And then we use apache config expressions remotely similar to this to map a part of URL (or DNS request domain) to pass a specific ?kc_idp_hint=<CUSTOMERID> to the Keycloak login request."

* Question by @reqa to @jnull (async via chat): "I guess this is the point you were refering to in the IAM SIG last Friday: https://github.com/zmartzone/mod_auth_openidc/blob/master/auth_openidc.conf#L32 - where it explicitly says that OIDCProviderMetadataURL is only suitable with a single static OIDC IdP and we must switch to OIDCMetadataDir to make dynamic config possible."

## Research session (@reqa): What would need to be changed regarding Keystone/apache wsgi-config to support dynamic addition of new customer realms
* https://github.com/zmartzone/mod_auth_openidc/blob/master/auth_openidc.conf#L32
    * `OIDCProviderMetadataURL` is only suitable for `single static provider`
    * We would need to use `OIDCMetadataDir`
* What about the `OIDCDiscoverURL` in the generic LocationMatch `/v3/auth/OS-FEDERATION/identity_providers/keycloak/protocols/openid/websso`?
    * https://github.com/zmartzone/mod_auth_openidc/discussions/745
* What about the `OAuth2TokenVerify` in the generic LocationMatch `/v3/OS-FEDERATION/identity_providers/keycloak/protocols/openid/auth` (which is `mod_oauth2` specific)
    * `This primitive can be used multiple times in which case the access token will be verified in order - according to each consecutive primitive - until it validates or reaches the end of the list.` -- Nice, but has the problem that this would need to be made dynamic. Interesting points to dive deeper:
        * https://github.com/zmartzone/mod_auth_openidc/discussions/745
        * https://groups.google.com/g/mod_auth_openidc/c/1TCke4Q8KZg
        * https://github.com/zmartzone/mod_auth_openidc/wiki  (The FAQ with examples for URL matching and `OIDCDiscoverURL`)


