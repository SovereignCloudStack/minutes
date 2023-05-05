# Gaia-X Tech-X Hackathon #6

## Self description generation via infrastructure discoverability features

[Gaia-X](https://gaia-x.eu) [Tech-X / Hackathon #6](https://gaia-x.eu/tech-x/)
2023-05-03/04 Bilbao

[Max Wolfs](https://scs.community/wolfs), [Kurt Garloff](https://scs.community/garloff)
[Sovereign Cloud Stack](https://scs.community/), [OSB Alliance e.V.](https://osb-alliance.com/)

* Intro slides (editable): <https://scs.sovereignit.de/nextcloud/s/gip7SZBjDpyHDQZ>
* Final slides<https://input.scs.community/tech-x6-results>
* Code Repository: <https://github.com/SovereignCloudStack/gx-self-description-generator>

## Proposal

<https://gitlab.com/gaia-x/gaia-x-community/gx-hackathon/gx-hackathon-6/-/wikis/Proposals#37-self-description-generation-via-infrastructure-discoverability-features>

### #37 Self description generation via infrastructure discoverability features

*Type*: Hackathon

*Title*: Creating self-descriptions using the discoverability platform features.

*Description*: While some of the self-description attributes like legal person and company number only exist in small numbers and don't change very often, this is not the case for technical properties of on-demand infrastructure such as clouds and k8s clusters. Clouds tend to evolve more quickly, the k8s clusters even are created and scaled on-demand. Properly self-describing them requires that the creation of these self-descriptions is automated. Fortunately, both OpenStack and Kubernetes support discovering the most relevant attributes. This was worked on in a previous Hackathon, the result is on github[1]. The tool creates JSON-LD that is in-line with the then discussed attributes and SD format. It only covers the OpenStack IaaS platform and while it's listing all services, it only retrieves details for some of them. During the Hackathon, we want to extend the coverage and most importantly start covering the Kubernetes clusters. We also need to be bring the attributes up-to-date with respect to the currently discussed vocabulary. The vocabulary likely will benefit from being extended; generating proposals to do just that is a wanted side-benefit of the hacking session. There will be remote participants from at least the SCS community contributing and supporting. <https://conf.scs.koeln:8443/GX-Hackathon6>
[1] <https://github.com/SovereignCloudStack/gx-self-description-generator>

*Relation to goals*: We do develop tools for creating Self-Descriptions

*Responsible*: Max Wolfs wolfs@osb-alliance.com (SCS Project @ OSB Alliance e.V.) Supported (remotely) by SCS community members and WG Srv Char members.

*Goals & Outcomes*: Participants understand the (draft) technical attributes to characterize infrastructure services (OpenStack and Kubernetes). They will have tooling to generate self-descriptions by querying the relevant APIs. This will serve as useful input / feed-back again to the service characteristics working group again.

*Expected knowledge*: Gaia-X Self-Descriptions, Python, OpenStack API, Kubernetes API

*Requirements*: Access to OpenStack clouds and/or k8s Clusters (cluster-API), talk to us (SCS) beforehand if you want to use our envinroments to work against.

*Dev Environment*: Computer/VM with python, openstackSDK, python kubernetes-client.

## Participants

* max Wolfs <wolfs@osb-alliance.com>
* kurt Garloff <garloff@osb-alliance.com>
* raul.minon@tecnalia.com
* isabel.torre@tecnalia.com
* juan.lopezdearmentia@tecnalia.com
* gorka.Benguria@tecnalia.com
* gorka.zarate@tecnalia.com
* roman.hros@dnation.cloud
* matej.feder@dnation.cloud
* mark.emodi@sztaki.hu

Gaia-X organization:
Cristina Pauna <cristina.pauna@gaia-x.eu>

## Goals

Modern (cloud/container) infrastructure is fluid – changes very quickly, so difficult to self-describe.
Modern infrastructure is discoverable, so can be automatically self-described.

Generate technical Gaia-X automatically by using discovery:

* Demonstrated successfully during Hackathon #4 for OpenStack Infra
* Adjust to current Gaia-X standards, adjust to current infra attributes, discover more of OpenStack, discover k8s clusters (as cluster-admin), discover other infra, include validation, include signing, …
* Working python code on github, extending <https://github.com/SovereignCloudStack/gx-self-description-generator>

## Links

What | URL
-----|-----
Proposal | <https://gitlab.com/gaia-x/gaia-x-community/gx-hackathon/gx-hackathon-6/-/wikis/Proposals#37-self-description-generation-via-infrastructure-discoverability-features>
Hack#4 SD generator | <https://github.com/SovereignCloudStack/gx-self-description-generator/>
Gaia-X SD current schema | <https://github.com/SovereignCloudStack/gx-self-description-generator/blob/main/doc/20230424-sd-schema.md>
Gaia-X current service schema | <https://gitlab.com/gaia-x/technical-committee/service-characteristics/>
Gaia-X service ontology 2022-05 | <https://gaia-x.gitlab.io/gaia-x-community/gaia-x-self-descriptions/service/service.html>
Gaia-X compliance checker | <https://compliance.lab.gaia-x.eu/>
Gaia-X framework | <https://docs.gaia-x.eu/framework/>
Gaia-X trust framework | <https://gaia-x.gitlab.io/policy-rules-committee/trust-framework/>
~~SD signer (DeltaDAO)~~ | <https://signer.demo.delta-dao.com/#signer>
OpenStack SDK | <https://docs.openstack.org/openstacksdk/latest/>
K8S Python bindings | <https://github.com/kubernetes-client/python>
K8S Go interface | <https://github.com/kubernetes/client-go/>

## Agenda

<https://gaia-x.eu/tech-x-agenda/>

Sala Bastida, Level -2 and <https://conf.scs.koeln:8443/GX-Hackathon6> (Jitsi)
Headphones recommended for those in Bilbao

May 3: (Event starts at 9:30)
11:30 – 13:00 Hackathon Kick-Off
14:30 – 16:00 Hacking
16:45 – ...  Intermediate Hacking results

May 4:
 9:00 – 10:30 Hacking
11:15 – 12:45 Hacking
14:20 – 16:00 Final Hacking results
16:45 – 17:10 Hackathon Winner presentation (Auditorio, Level -1)

## Hacking preparation

* Laptop / VM with python3
* Openstack-SDK (for OpenStack IaaS)
* K8s python bindings / go (for k8s discovery)
* Optional: opentackclient and kubectl tools
* Familiarity with Self-Descriptions (see Links)
* Familiarity with existing tool (see Links)
* Familiarity with Gaia-X Lab Compliance Checker, Signer
* Familiarity with git / github

Send github names to Kurt (garloff@osb-alliance.com), so they can receive privileges on the SD generation repo (for branches without forks)

## Available test/work infrastructure

* OpenStack discovery can run against any (not too badly customized) OpenStack
* K8s discovery should work against any k8s cluster (with admin privilege access level)
* Sovereign Cloud Stack will have OpenStack and k8s Endpoints to work against if participants don’t bring their own
  * Thanks again to [PlusServer](https://plusserver.com/) for generous support with test environments in their SCS PlusCloud Open
  * Will provide access data here b/f the Hackathon starts
    * Download OpenStack [clouds.yaml](https://scs.sovereignit.de/nextcloud/s/Xk5wXfDtT5jXksc), kubeconfig [gx-hack6-1.yaml](https://scs.sovereignit.de/nextcloud/s/QyrCwiABs8LBBXt) and [gx-hack6-2.yaml](https://scs.sovereignit.de/nextcloud/s/NsZiq8BSrTQ59xp)

```yaml
clouds:
  gx-h61.1:
    region_name: "RegionOne"
    interface: "public"
    identity_api_version: 3
    auth_type: "v3applicationcredential"
    auth:
      auth_url: https://api.gx-scs.sovereignit.cloud:5000
      #project_id: 1846709967a744b69f9eb48cac89bb04
      application_credential_id: "0c8a63f6ea8c4262ae1e6b13736ca794"
      application_credential_secret: "EOimOJdcuHx9EgTK8ynHtGbSBBlMi8W4NUwUBu47Q1jCI9IgxR-On1R1hKUm1HxCGlEaykYjOsxNeIP9rjWZPg"
```

(Further application credentials / access options can be created.)

## Available collaboration infrastructure

* Video-Conf <https://conf.scs.koeln:8443/GX-Hackathon6> (Jitsi)
  * Jitsi is ran by the [SCS](https://scs.community/) team in [Cleura](https://cleura.com/) OpenStack cloud, thanks Cleura!
  * We can create as many breakout rooms as we want ...
  * Builtin chat and etherpad
  * Power-user hint: Jitsi allows several simultaneous screen shares, use tile view to switch
* Alternative: Matrix Chat: NO (no matrix accounts by some participants)
* Alternative: HedgeDoc pad (like etherpad, markdown rendering): YES
 <https://input.scs.community/GX-Hackathon6>
  Let's use this headgedoc to share and record results, learnings, ...
* Collaborative slideware: SCS Nextcloud
  <https://scs.sovereignit.de/nextcloud/s/gip7SZBjDpyHDQZ>
  We can online edit the slides (Collabora) to create our final presentation

## Ideas for Hack subprojects in SD Gen session

1. Adjusting to latest Gaia-X standards
    * Has the preamble changed?
    * Study Self-Description Schema for infra services
    * Adjust generator to be compliant
    * What’s missing in the schema?
        * Does it have the right approach/properties for virtual infra?
    * What’s missing in the generator?
2. Validation and Signing
    * Interact with Gaia-X Compliance Checker
    * Do signing with own key (and expose public key via <https://$YOURDOMAIN/.well-known/did.json>)
    * Interact with official signer / Delta-DAO signer to get Verifiable Credential
    * Integrate this into the gx-self-description-generator
3. More OpenStack discovery
    * Flavor extra_specs
    * Loadbalancer providers and flavors
    * Neutron features (FWaaS, VPNaaS, …), IPv6
    * Public networks, Provider networks, Floating IP networks
4. Characterize Kubernetes cluster
    * Nodes: (Number, type, arch, kernel version ...)
    * K8s version
    * CCM, CNI, CSI, … (and versions)
    * Discover Services: Metrics, Flux, Cert-Manager
    * More Services: Ingress, Gateway API
    * More Services: ...
5. Characterize K8s cluster aaS
    * Conceptual work
    * What is parametrized, what are the limits
    * Cluster-API (lacking some discoverability)
6. Your ideas?

## Help

![maxwolfs](https://input.scs.community/uploads/a534f24c-575c-4afa-825d-c9f5d23d6671.png)
Maximilian Wolfs
<https://scs.community/wolfs>
SCS Knowledge Management Engineer
on-site in Bilbao

![garloff](https://input.scs.community/uploads/a9ef84ef-dd9f-422a-a19f-1c6fef86f3bf.png)
Kurt Garloff
<https://scs.community/garloff>
SCS CTO
Remote

[ ]
Anja Strunk
Gaia-X TC WG Service Characteristics Co-Chair
out sick :-(

![cpauna](https://input.scs.community/uploads/1810a3bd-6ce0-44f6-b77d-0f81e9316cbb.png)
Cristina Pauna
cristina.pauna@gaia-x.eu
Gaia-X OSS Community Mgr
On-site in Bilbao

## Demo

```bash
garloff@garloff-X400(//):/casa/src/SCS/gx-self-description-generator [0]$ ./gx-sd-generator.py --gaia-x --os-cloud=gxscs-comm
```

```json
{
  "@context": [
    "http://www.w3.org/ns/shacl#",
    "http://www.w3.org/2001/XMLSchema#",
    "http://w3id.org/gaia-x/resource#",
    "http://w3id.org/gaia-x/participant#",
    "http://w3id.org/gaia-x/service-offering#"
  ],
  "@type": [
    "VerifiableCredential",
    "ServiceOfferingExperimental"
  ],
  "@id": "https://scs.community/sd/gxserviceIaaSOfferingOpenStack-test-1683036308.json",
  "credentialSubject": {
    "id": "https://scs.community/sd/gxserviceIaaSOfferingOpenStack-test-1683036308.json",
    "gx-service-offering:providedBy": {
      "@value": "https://scs.community/sd/participant.json",
      "@type": "xsd:string"
    },
    "gx-service-offering:name": {
      "@value": "OpenStack IaaS Service SCS Test",
      "@type": "xsd:string"
    },
[…]
    "gx-service-offering:SDAutoGeneratedBy": "https://github.com/SovereignCloudStack/gx-self-description-generator/",
    "gxsvo+OpenStackService": {
      "regions": [
        "RegionOne"
      ],
      "auth_url": {
        "@value": "https://api.gx-scs.sovereignit.cloud:5000",
        "@type": "xsd:anyURI"
      },
      "RegionOne": {
        "identity": {
          "name": "keystone",
          "endpoint": {
            "@value": "https://api.gx-scs.sovereignit.cloud:5000",
            "@type": "xsd:anyURI"
          },
          "versions": [
            {
              "version": "3.14",
              "url": "https://api.gx-scs.sovereignit.cloud:5000/v3/",
              "status": "CURRENT"
            }
          ]
        },
[…]
        "orchestration": {
          "name": "heat",
          "endpoint": {
            "@value": "https://api.gx-scs.sovereignit.cloud:8004/v1/${OS_PROJECT_ID}",
            "@type": "xsd:anyURI"
          },
          "versions": [
            {
              "version": "1.0",
              "url": "https://api.gx-scs.sovereignit.cloud:8004/v1/",
              "status": "CURRENT"
            }
          ]
        },
        "cloudformation": {
          "name": "heat-cfn",
          "endpoint": {
            "@value": "https://api.gx-scs.sovereignit.cloud:8000/v1",
            "@type": "xsd:anyURI"
          }
        }
      }
    }
  }
}
```

## Getting started

* Download [clouds.yaml](https://scs.sovereignit.de/nextcloud/s/Xk5wXfDtT5jXksc) to `~/.config/openstack` and the kubeconfig files [gx-hack6-1.yaml](https://scs.sovereignit.de/nextcloud/s/QyrCwiABs8LBBXt) and [gx-hack6-2.yaml](https://scs.sovereignit.de/nextcloud/s/NsZiq8BSrTQ59xp) to `~/.kube/`. (If you have non-empty clouds.yaml there already, you can store the new one also in the current directory -- openstack tools/sdk search current dir first.)
* You have python3 (>= 3.6) and pip/pip3 available on your machine
* Install openstacksdk and openstackclient from your distro's package management (e.g. `apt-get install python3-openstackclient python3-openstacksdk`) or via pip.
* Install kubectl, e.g. (on Ubuntu) using `snap install kubectl --classic`
* Install kubernetes python support (e.g. `apt-get install python3-kubernetes`) or via pip.
* `git clone git@github.com:SovereignCloudStack/gx-self-description-generator` and `cd gx-self-description-generator`
(Use `https://github.com/SovereignCloudStack/gx-self-description-generator` instead of `git@...` if you don't have a github account.)
* Test cloud access: `openstack --os-cloud=gx-h61.1 catalog list`
* Get the python code (OpenStack discovery) to work:
`./gx-sd-generator.py --os-cloud=gx-h61.1`
* Look at the built-in help: `./gx-sd-generator.py --help`
* Power-user tip: Move `clouds.yaml` to `~/.config/openstack/` and `export OS_CLOUD=gx-h61.1`, so you don't need to pass `--os-cloud=gx-h61.1` for openstack tools  
* Test access to the cluster 1:
  * first: `export KUBECONFIG=~/.kube/gx-hack6-1.yaml`
  * then: `kubectl get nodes -o wide`
        or `kubectl get pods -A`
        or `kubectl get svc -A`
* Should work for cluster 2 as well.
* The `gx-sd-generator.py` script does not yet support collecting k8s infos ... PRs welcome :+1:
* Contributing:

``` bash
git checkout -b feat/my-contribution    # create and checkout feature branch, use descriptive name instead of my-contribution
# Do work, test, document, ...
git add FILES        # Use real files, avoid -a 
git commit -s        # The signoff -s is important
git push             # will result in error messages, as you need to push to the correct tracking branch
git push origin ....        # Use the recommended syntax
# Open pull request via github web interface
```

* Technical details can well be discussed in PR (or in issues)

## Random notes / learnings from the hacking

* some struggling with getting python openstacksdk working (Tecnalia) -> resolve asynchronously
* openstack-discovery.py working, gx-sd-generator.py not -> [issue #35](https://github.com/SovereignCloudStack/gx-self-description-generator/issues/35)
* Delta-DAO signer still active (TODO: Clarify @garloff)
* Validation: Is there a Web-Frontend somewhere or do we need to get the scripts from gitlab working? (TODO: @matofeder)
* (Fabian): I created a Dockerfile that does the bootstrapping which you may use :)
<https://gist.github.com/FabianScheidt/beaae118763b27fd40df7e9b57d4a201>

---
Enjoy lunch, see you back at 14:30.

---

Updates from @matofeder, @chess-knight:

* New version of signer: <https://wizard.lab.gaia-x.eu/>
* SD-creation wizard: <https://sd-creation-wizard.gxfs.dev/>
  * Does not agree with with v22.06
* Schema to validate against: <https://gaia-x.gitlab.io/technical-committee/service-characteristics/v22.06/downloads/>
  * Use the shacl shapes
  * Latest released version is v22.10 (but not available for download), git HEAD branch is even further
  * python script to validate (@matofeder, @chess-knight)
  * service-offeringShape.ttl
  * generated SD fails
    * @context header: list not accepted, needs to be dict (key-value)
    * credentialSubject may be used in a wrong way
      * It's not checked?
    * @type wrong?
    * @providedBy needs to be outside of credentialSubject?
  * Use <https://gitlab.com/gaia-x/technical-committee/service-characteristics/-/blob/develop/implementation/instances/gax-trust-framework/service-offering/BareMetalServiceOffering.jsonld> as example
  * Script will be contributed to github/SCS/gx-self-description-generator
  * Ewann Gavard (from gaia-x) will be asked to review

=> Continue to work on this

Updates on k8s-discovery:

* Framework started (only lists pods currently as PoC)
* kubeconfig and kubecontext can be configured (but are not yet used)
* Tecnalia will submit improved version

Updates from Juan:

* JSON-LD generated from openstack-discovery.py
  * Openstack services: dns, compute, orchestration, ... are NOT defined by any shape
    * We are ahead of the Service Characteristics
    * Should suggest Schema (SHACL shapes) for Kubernetes and OpenStack

Updates from Gorka:

* Work on pipelines with Juan, automate steps:
  * JSON-LD
  * Signing
  * Compliance Check

Updates from @maxwolfs
    *We should meet at 16:10 to finalize the results collection for the intermediate results presentation
    * We do this with HedgeDoc Slides, yeah: <https://input.scs.community/tech-x6?both>
     * PLEASE fill those slides as we go, so we have them 80% done by 16:10 :-)

Updates from Raul, Ana:

* k8s-discovery started, modeled after openstack discovery
* Does already collect information from k8s (nodes centric, mostly)
* [PR](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/37) open, needs a bit more work to be mergable
* Not yet called from / integrated into gx-sd-generator.py (will happen tonight or tomorrow)

---

Thursday 4th of May

* The final slides have to be commited until 14:00 CEST
  * [link to final slides](https://input.scs.community/tech-x6-results)
  * Will go through our pre-final slides at 12:30 CEST
* Minimal service SD added to git, shapes to validate them from current git main branch (which is also used by the wizard). We pass the validation. Still all technical attributes of OpenStack and K8S need to be invented by us (there is no standard for these yet). Should go back to Svc Char WG and suggest our way of describing as standard.
  * Wizard only accepts SD *without* the context header that links the content to the shapes (id, type added by wizard after selecting the type in the dropdown)
  * REST API of compliance service will be tested (maybe it does accept the SD with the context header?)
  * Working through the flow of the Wizard Web-UI ...
    * Signing happens in .js code (no backend call)
    * Where is the header added? (@matofeder will seek information in Matrix chat)
    * Confirmed: Validation and Signing in JS (webCrypto), so private key remains local in browser. Ref: <https://gitlab.com/gaia-x/lab/compliance/gx-compliance/-/blob/development/src/common/services/signature.service.ts#L104>
  * Our flow could be:
    * Produce SD (including context headers etc.)
    * Sign it locally with private key (in python code), using the same normalization/canonization and signing approach as the JS code (if we find suitable py lib that helps us :-)), public key needs publication as DID:web
    * Submit to compliance service [REST API](https://compliance.lab.gaia-x.eu/development/docs/#/credential-offer/CommonController_issueVC) to get counter-signed VC back, currently returns 409 (even on the example), latest unstable version works (<https://registry.lab.gaia-x.eu/api#menu>), but we get a 500 ...
      * 500 is not a good response, TODO: submit bug report to <https://gitlab.com/gaia-x/lab/compliance/gx-compliance>
    * Trouble with `type` vs. `@type`
    * Do we need a valid DID (with a published public key for DID validation at <https://$DOMAIN/.well-known/did.json> ?), used Walt.ID tool in Hack#4: <https://github.com/walt-id/waltid-ssikit>, documentation: <https://github.com/walt-id/waltid-oceandao-docs> (but assumes blockchain publication)  - this is more than we can do in the remaining hour
* Mark will submit a PR with changed shebang to address the issue when running the SD generator in a venv. Done, [PR #41](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/41)
* Large (and really great) contribution from Tecnalia needs work ([DCO](https://docs.scs.community/community/community/github/dco-and-licenses), split, minor nitpicks) to be mergable.
  * Mergability improvements happening today
    * Airflow pipeline: [PR #42](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/42), merged
    * Timestamp, extension, reference output: [PR #43](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/43), merged, improved docu [PR #44](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/44), merged
  * More properties of k8s will be added. :thumbsup:
    * Merged with [PR #47](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/47)
* More Gaia-X shapes work:
  * Latest shapes [PR #45](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/45)
  * `ex:` prefix [PR #48](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/48)
* Dockerfile [PR #46](https://github.com/SovereignCloudStack/gx-self-description-generator/pull/46)
