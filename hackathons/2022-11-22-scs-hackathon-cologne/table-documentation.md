# 2022-11-22 SCS Hackathon

## Hackathon Table Documentation

Collection of topics to discuss

### Toolchain: Rendering Engine / Static Page Generator

#### Main goals for SCS documentation

* As easy for external and interal comsumers as possible
* As automatable as possible for internal and external contributors and maintainers

#### File format

* We prefer to use .md for now, but want to leave option open for .rst in the future

* there is a .rst plugin for docusaurus
* possibility of pandoc workflow for converting .rst to .md

#### reasons for choosing docusaurus

* typescript as strongly typed language for better code
* node.js with nvm and npm environment easier
* big open source communtiy
* single page application for faster/better UX
* scs community more leaning to python based static page generators

### How do individual repositories documentations come togehter?

Described in this [issue](https://github.com/SovereignCloudStack/docs-page/issues/1)

* decision: git subtree proposal described @maxwolfs in issue/1 doesn't work out as it is too much overhead for contributing organisations

#### Alternative 1

* github actions workflow transforming target repo into consumable content for docusaurus - only markdown files
* cloning target repo, stripping it down with custom workflow for only having markdown files left and copying to  /docs sub-directory
* question: should the workflow happen within the docusaurs docs-page repository or within another proxy repository acting like a docs package manager?

#### Alternative 2

* back-up strategy
* importing target repo as-it-is directly to /docs-page with all its code as git subtree git submodule

#### hacking session

* Alterantive 1 works – see this example workflow in demo repo: [Link](https://github.com/tibeerorg/saurus/blob/main/.github/workflows/syncronize_tibeerorg_testbed.yml)
* name proposal for proxy repo: "docs distillery" (sidenote: fits a proper hackathon born naming)
* proxy repo seems too much overhead for our aim to quickly having an implemenation, considering deadline of openstack-image-manager

#### Decisicion

As Alternative 1 seems to work out well, we have decided to use this for implementation

### Rules on Contributors Guide and Documentation Structure

Described in this [Issue](https://github.com/SovereignCloudStack/docs-page/issues/2)

* We need a quickstart guide: how to docs repo with our docs system
* link to "how to markdown" guide and markdown linter
* link to "how to git" guide and SCS Contributor guide
* repositories should start with a small letter
* we want one clear and concies path for a single how-to-guide – no if or subpaths within one guide
* nice to have: "was this helpful?" for direct feedback or comments (s. <https://giscus.app/de>)
* codeblocks must be wrapped with markdown code syntax and language must be specified
* Admonitions / Notes: Taxonomy must be clear – when to use warning, when to use Cautions, Tips etc. (s. <https://docusaurus.io/docs/2.0.1/markdown-features/admonitions>)
* No files must be named README.md within the /docs directory
* there is a usecase for personas that might need an offline documentation aka good printable version

#### What we want

* markdownlint
* svg first, png only for cases where e.g. GUI Screenshotss are essential for better understanding and UX

#### To-do

* Language Style Constraints like tense, first/third person narration, etc.

### Deployment / Release Pipeline and Versioning / Landing Page

* Versioning should happening manually when SCS major releases are being made
* Docs Page could be the new entry point for the main website scs.community as the technical topic might be more important than policitcal content
* Documentation of how the pipeline works (like <https://docs.zephyrproject.org/latest/contribute/documentation/generation.html>)

### Roles / Personas

* Users/Consumers
* Operators
* Developers
* Evaluators (Quickstarters)
* Managers (maybe not)

* We need a better understanding of who consumes the docs-page to adapt to their needs, see goal 1
* Discussion about User Journeys next SIG Community on 2022-11-28 CET 11:05 AM

### Openstack Image Manger

* Openstack Image Manger should work as template or reference for all future documentations

#### Documentation Structure

Proposal for a division of the documentation:

* Overview - mandatory
    * What is it, what do I need it for? Benefits?
    * What organization/company does this belong to? (Link to Osism main documentation?)
    * Where am I – as module – within the bigger context of SCS?
* Requirements - mandatory
    * What minimal requirements do i need to quickstart?
* Quickstart - optional. If it is possible, then mandatory
    * Link to requirements
    * What is the aim of this quickstart guide?
    * Caution: only for testing, not for production
    * Rule: one line per command for easy copy&paste and one line for description where possible
    * Rule: only one working path for installation!
* Getting Started - mandatory
    * Aim is a production ready installation
* Configuration – mandatory
    * Showing all possible config options
* Contribute – mandatory
    * Description for how can i contribute with Link to Github repository
* FAQ`s – optional
* Roadmap - optional
