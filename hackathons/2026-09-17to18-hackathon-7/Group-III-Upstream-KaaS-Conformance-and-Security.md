---
tags: scs,hackathon,hackathon7,2026
title: SCS Hackathon 7 - Group III Upstream KaaS Conformance and Security
---

# SCS Hackathon 7 - Group III: Upstream KaaS Conformance and Security

Room: 01.006 “Utter Upstream”

## Participants

- @garloff
- @janiskemper
- @MartinMai
- @selisosba
- @mbuechse

## Meeting room
https://meet.academiccloud.de/gl/rooms/c4v-5zb-6dd-xer/join


## Minutes

### Security requirements
Goal / Motivation
- Users that use SCS should be able to get a number of checkmarks behind security requirements

#### Strategy: Security as part of SCS-compatible?
- Do we want to have security requirements? It's not strictly interoperability ...
- But workload operators typically have security as a requirement and want to use the same concept and implementation across various cluster providers, so it is an interop topic
- Folks that need to do BSI / xxx certifications might appreciate to get a few easy checkmarks ...
- New label SCS-secure? or part of SCS-compatible? ~~-open?~~ -sovereign?
	- Avoid making things more complex ...
- Is our contribution relevant (compared to armies of security folks)?

| Layer\Dimension | DataS9y | Compatible | Open | Sovereign |
|-------|----------|-------|------|-----------|
| IaaS  | x | SCS-compatible IaaS | SCS-open IaaS | SCS-sovereign IaaS |
| KaaS  | x | SCS-compatible KaaS | SCS-open KaaS | SCS-sovereign KaaS |



#### Secure cluster workloads requirements classification

( a) Some of them are purely user (workload operator)
( b) Some of them need to be done by provider -> SCS
( c) Some of them need both (e.g. enabled by provider and documented how to be used by user) -> SCS? (Documentation requirement?)

#### Sources for security requirements
- BSI / Thomas Fricke
	- https://github.com/thomasfricke/training-kubernetes-security/blob/main/Overview.ipynb
	- https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Grundschutz/IT-GS-Kompendium_Einzel_PDFs_2022/07_SYS_IT_Systeme/SYS_1_6_Containerisierung_Edition_2022.pdf?__blob=publicationFile&v=3#download=1
	- https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Grundschutz/IT-GS-Kompendium_Einzel_PDFs_2022/06_APP_Anwendungen/APP_4_4_Kubernetes_Edition_2022.pdf?__blob=publicationFile&v=3
	- Scanning recommendation: Kubescape and Grype
- NIST (STIG viewer): https://www.stigviewer.com/stigs/kubernetes / https://ncp.nist.gov/checklist/996/download/18641
	- Gardener has done assessment: https://gardener.cloud/docs/security-and-compliance/kubernetes-hardening/
- Haven+: https://gitlab.com/commonground/haven/haven/-/blob/main/haven/cli/pkg/cncf/validate.go?ref_type=heads#L66
- Vorgaben für Architektur von Opendesk 
    - Laut Thomas Fricke noch aktuell aber GPU/AI(?) ist nicht mit beleuchtet
        - https://bmi.usercontent.opencode.de/opendesk-architekturkonzept/D_technologiearchitektur/
- Ankündigungen BSI Grunsschutz++ 
    - Versprechen neu unter anderem:
        - automatisch testbar
    - https://www.bsi.bund.de/DE/Themen/Unternehmen-und-Organisationen/Standards-und-Zertifizierung/Grundschutz-in-der-Informationssicherheit/Grundschutz-Plus-Plus/grundschutz-plus-plus_node.html
#### SBOM (-> SCS-open)
- syself has public page https://syself.com/versions
    - z.B. https://syself.com/versions/1-36/v5
	- uses input from VEX (Vulnerability Exploitability eXchange)

## side input from container.gov.de
* today asked in chat by devguard people, that we assume right
    * can be subscribed pulled and pushed from and hinted to for audits (not local but guaranteed by central trusted party)
    * https://devguard.opencode.de/%40opencode/projects/badgebackend/assets/badge-api/refs/main
* additional things at container.gov to look at 
    * current requests about badges 
        * https://gitlab.opencode.de/oci-community/documentation/sgci-governance/tab/decisions/-/merge_requests 
## Was / wie weiter
* Es gibt verschiedene Best Practices, z.B. von der NIST STIG, die evtl. nicht automatisiert getestet werden können und teilweise auf User-Ebene nicht Provider-Ebene sind.
* Wir nutzen CNCF Conformance, jetzt schon
* Wie gehen wir weiter? Wollen wir z.B. offiziell auf STIG verweisen, was aber unsere Zertifizierung verkomplizieren würde?
* Wollen wir STIG NICHT aufnehmen, nur weil wir es nicht komplett automatisiert testen können?
* Wollen wir STIG aufnehmen, sodass man eine Tabelle wie Gardener hat, mit denen User alle Anforderungen (die sie teilweise selber umsetzen wollen) auch umsetzen können?
* eher Wissensvermitlung anstatt Zertifizierung?
* Nische oder als relevant ins Licht treten/ Best practice für DS Cloud-Infrastruktur
* nur automatisiert Testen wollen hat Grenzen / Auswirkungen wo es hingehen kann 
* Ist unser Wissen der Auswahl an relevanten Kriterien hinsichtlich security ausreichend, sodass wir auf dieser Basis security-Anforderungen in die Standardisierung überführen können? 
     * man machts gar nicht
     * man pickt sich nur einzelne Dinge raus
     * man übernimmt alles

* Mögliches Ziel: Unser Anspruch ist, dass im Bereich SCS security alle NIST-technischen Standards erfüllt werden. 
    * Der Scope der SCS Standards ist, dass auf der Konfigurationsebene der Kubernetes Cluster CNCF/NIST/BSI (ohne Prozessanfordeungen) entspricht. Das Vesprechenn an die Enduser ist dann, dass wenn ich meine User-Themen lt. CNCF/NIST/BSI beitrage und ich einen SCS certified Provider habe, ich NIST & Co. erfülle. (Die User-Themen sind entsprechend aufbereitet in eienr Übersichtstabelle, siehe oben) Ein Thema sind dann zum Beispiel die Node-Images. 

### SCS contribution to standardization & certification
What do others do, where can we create added value that brings relevance to SCS conformance?

Options:
1. The added value could be in knowing the requirements for interoperability for our users (DevOps teams for workloads) better than others and select the best selection of relevant standards, composed of upstream (CNCF, NIST, BSI, ...) standards plus filling the gaps if any. This way we reduce the (non value-adding) fragmentation of open/sovereign solutions.
2. Our quality of certification is higher than elsewhere. Instead of long check lists, we have automated tests for ideally all (but at least most) requirements that users can run and that are applied continuously to provide transparency on compliance to providers and users alike.

Thus far we aspired to do both, but it seems we need to take a decision w.r.t. security (or maybe more generally non-functional) requirements, where test automation capability is assumed to be lower. Thus completeness vs. automation. Middle ground may be the worst of both worlds ...

### Node image standards
We want to write an issue and start a discussion with providers on best practices for node images. Among others:
- signed images
- dm-verity (verification that nodes have not been tampered)
- SBOMs

## Should SCS-compatible (dimension two of digital sovereignty = provider switch capability) require data protection proof (dimension one)?
- 90+% of industry assumes sovereignty = data sovereignty
- We have a hard time (but some success) to explain that it's more
- But to then say that we don't cover the basics (data sovereignty)

So should we somehow require data sovereignty proof before certifying SCS-compatible?
- Would need to curate suitable certifications, proofs

Discussion
- EU focus (GDPR)
- Providers need to fulfill legal requirements anyhow
- Do we have skills and credibility to assess anything in this space?
- Could cause significant additional pain for providers to pursue formal certification/proof

-> not pursuing

Idea:
- Data sovereignty is more than GDPR compliance
  - Is there a delta between legal data sovereignity and our definition of data sovereignity (on a technical level)?
  - Do we want to develop a definition, criteria and assessment for these and certify as on-ramp to SCS certification?
  - High requirements might be part of SCS-sovereign (dimension 4), not dimension 1.

- maybe additionally look at discussion for attestation / badge criteria at opencode
    -  https://gitlab.opencode.de/oci-community/documentation/sgci-governance/tab/decisions/-/merge_requests/1
    - Adds a document defining what "secure" and "sovereign" mean for container.gov.de, decomposing both terms into individually cited, checkable requirements traceable to primary....

## Future
- We need to work on SCS-open and SCS-sovereign!
- BSI could reference (or even adopt?) SCS standards and SCS compliance tests und this way help with relevance and visibility (@MartinMai)
