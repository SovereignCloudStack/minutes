# Gaia-X Hackathon #5 – Cloud Federation via OIDC & SSI-based Auth using Gaia-X SD & OPA / Rego

**Beware:** The contents of this pad will be publically available and stored on GitHub

## Participants (Prefer GitHub handles)
* @itrich
* @tibeer
* @fkr
* @matfechner
* @frosty-geek
* @garloff

# Day 1 (SSI-based Auth using Gaia-X SD & OPA / Rego)

* Introduction to walt.id by @philpotisk
* Live demonstration of walt.id SSI Kit (see https://github.com/walt-id/waltid-ssikit)

```
./ssikit.sh key gen -a RSA  # OR
./ssikit.sh key import ssl.pem
./ssikit.sh did create -k YOUR_KEY_ID -m web -d dids.walt-test.cloud
./ssikit.sh vc issue -t LegalPerson -i did:web:dids.walt-test.cloud -s did:web:dids.walt-test.cloud -v did:web:dids.walt-test.cloud --interactive --ecosystem gaiax legalperson.json
./ssikit.sh gaiax generate-participant -s legalperson.json
```

* Live demonstration of walt.id Web Wallet by @philpotisk (see https://github.com/walt-id/waltid-web-wallet)
* Introduction to walt.id IdP Kit by @severinstampler (https://github.com/walt-id/waltid-idpkit)
* Live demonstration by @severinbstampler on how to connect Keycloak with walt.id IdP Kit

### Resources 

#### SCS

https://github.com/SovereignCloudStack/Docs/tree/main/Design-Docs/IAM-federation

https://github.com/SovereignCloudStack/Docs/blob/main/Design-Docs/IAM-federation/Keycloak-Keystone-diagram.png


## User story

Jane Doe started to work for ACME Inc. and needs to work on cloud offering A and cloud offering B (aka: enjoy multi-cloud benefits), both federated by OIDC.

Necessary steps for Jane Doe to create a verified credential:
* Access your SSI Wallet
* Host https://github.com/walt-id/waltid-web-wallet or other SSI wallet yourself, or access https://wallet.walt.id (no-auth for demo)
* Create or import an RSA key (the one from your X.509 domain certificate)
* Onboard the Gaia-X Ecosystem:
* Settings -> Ecosystems -> Gaia-X “Add”
* Create & Register a did:web for your domain
* Create the LegalPerson Credential → self-signed via SSI Kit
* Create the Compliant Participant Credential → signed by Gaia-X Compliance API.
	
# Day 2 (Cloud Federation via OIDC)

## Summary of possible forecasted issues: (WIP)
    
Glossary:
* CSP = Cloud service provider

Scenario:
* CSP Alpha (with OpenStack + Keycloak Alpha)
* CSP Beta (with OpenStack + Keycloak Beta)
* Company ACME with user Jane Doe
  * without any IAM (but with a SSI in a wallet)
  * on own Keycloak ACME
  * on third party Keycloak SaaS provider
    
Goal:
* Jane Doe should be able to login to CSP Alpha as well as CSP Beta (optionally by using the third party Keycloak provider.)
    
Issues:
* https://github.com/SovereignCloudStack/minutes/pull/60 the miro sketchup we did discuss showing the challenges
* Jane Doe needs so sign in to have an entity on Keycloak Alpha and Keycloak Beta. How will rights and privileges then be mapped by Keycloak Alpha and Beta without knowing anything about Jane Doe (besides her company)?
  * Maybe a pull-based strategy from each CSP is a solution, but not very compfortable (CSP pulls information from companies Keycloak?)
* CSP's have to setup own Keycloaks that have to accept everything from the third party Keycloak provider.
* This can lead to admin rights for example on a complete CSP cloud.
  * It *should* be limited to a domain
* It will also not tackle the permission rights Jane Doe has to have on different CSPs.

## Integrating walt.id IdP into Keycloak on SCS testbed
* Added walt.id IdP as Identity Provider in Keycloak via https://idp.walt-test.cloud/api/oidc/.well-known/openid-configuration
  * Client authentication: Basic auth
  * Scopes: openid gaiax

### Issue we ran into:
We ran into the issue https://github.com/keycloak/keycloak-ui/issues/3355 on our Keycloak 19.0.1 instance. To solve this, we manually replaced
```
"clientAuthMethod" : "clientAuth_Basic",
```
with
```
"clientAuthMethod" : "client_secret_basic",
```
via
```
/opt/jboss/keycloak/bin/kcadm.sh get realms/osism > osism.json
sed -e 's/clientAuth_basic/client_secret_basic/' osism.json > osism2.json
/opt/jboss/keycloak/bin/kcadm.sh create partialImport -r osism -s ifResourceExists=OVERWRITE -o -f osism2.json
```

We had to stop around 15:30 CEST on the second day with a 403 Error coming from Keystone which is probably not due to the integration we've done before.
