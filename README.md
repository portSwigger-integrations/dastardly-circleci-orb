# Dastardly Scan CircleCI Orb

[![CircleCI Build Status](https://circleci.com/gh/portSwigger-integrations/dastardly-circleci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/portSwigger-integrations/dastardly-circleci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/portswigger/dastardly.svg)](https://circleci.com/developer/orbs/orb/portswigger/dastardly) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/portSwigger-integrations/dastardly-circleci-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

This [CircleCI orb](https://circleci.com/orbs/) runs a Dastardly vulnerability scan against a target site. On completion, a JUnit XML report is generated containing information about the vulnerabilities found, where
they were located, additional information about the vulnerability and links to our learning resources with suggestions on how to fix them.

## About Dastardly

- [Dastardly](https://portswigger.net/burp/dastardly) is a free, lightweight web application security scanner for your CI/CD pipeline.
- It is designed specifically for web developers, and checks your application for [seven security issues](https://portswigger.net/burp/dastardly/scan-checks) that are likely to interest you during software development.
- Dastardly is based on the same scanner as [Burp Suite](https://portswigger.net/burp) (Burp Scanner).

For full documentation on using Dastardly, please consult the [Dastardly documentation](https://portswigger.net/burp/documentation/dastardly).

Already used Dastardly? [Tell us what you think here](https://forms.gle/8Va7ombB793HqFKw5).

## Inputs

## `target_url`

**Required** The full URL (including scheme) of the site to scan.

## `output_filename`

**Optional** The name of the output report file. This will be stored in the CIRCLE_WORKING_DIRECTORY (/home/circleci/project) directory.

**Default** `dastardly-report.xml`

## Examples
Below is an example of how to use the orb by running a Dastardly scan against our very own [Gin and Juice Shop](https://ginandjuice.shop) site. This is a deliberately vulnerable web application designed for testing web vulnerability scanners.

## Basic Usage
```
usage:
  version: 2.1
  orbs:
    dastardly: portswigger/dastardly-test@1.0.0
  jobs:
    scan-example:
      machine:
        image: ubuntu-2204:current
      resource_class: medium
      steps:
        - dastardly/scan:
            target_url: "https://ginandjuice.shop"
            output_filename: "scan_report.xml"

  workflows:
    use-my-orb:
      jobs:
        - scan-example
```

## Suggested Usage
  Dastardly produces a JUnit XML report of the scan on completion. This report will only include vulnerability details if vulnerabilities were found by the scanner.
  If Dastardly finds any issue with a severity level of `LOW`, `MEDIUM`, or `HIGH`, it will fail a workflow build.

  When you run tests in CircleCI there are two ways to store your test results. You can either use [artifacts](https://circleci.com/docs/artifacts/) or the [`store_test_results`](https://circleci.com/docs/configuration-reference/#storetestresults) step. Documentation for collecting test data can be found [here](https://circleci.com/docs/collect-test-data/).

```
usage:
  version: 2.1
  orbs:
    dastardly: portswigger/dastardly-test@1.0.0
  jobs:
    scan-example:
      machine:
        image: ubuntu-2204:current
      resource_class: medium
      steps:
        - dastardly/scan:
            target_url: "https://ginandjuice.shop"
            output_filename: "scan_report.xml"
        - store_test_results:
            path: "scan_report.xml"
  workflows:
    use-my-orb:
      jobs:
        - scan-example
```