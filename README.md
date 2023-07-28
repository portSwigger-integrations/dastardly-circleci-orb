# Dastardly Scan CircleCI Orb

[![CircleCI Build Status](https://circleci.com/gh/portSwigger-integrations/dastardly-circleci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/portSwigger-integrations/dastardly-circleci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/portswigger/dastardly.svg)](https://circleci.com/developer/orbs/orb/portswigger/dastardly) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

This [CircleCI orb](https://circleci.com/orbs/) runs a Dastardly vulnerability scan against a target site. On completion, a JUnit XML report is generated.

## About Dastardly

- [Dastardly](https://portswigger.net/burp/dastardly) is a free, lightweight web application security scanner for your CI/CD pipeline.
- It is designed specifically for web developers, and checks your application for [seven security issues](https://portswigger.net/burp/dastardly/scan-checks) that are likely to interest you during software development.
- Dastardly is based on the same scanner as [Burp Suite](https://portswigger.net/burp) (Burp Scanner).

For full documentation on using Dastardly, please consult the [Dastardly documentation](https://portswigger.net/burp/documentation/dastardly).

Already used Dastardly? [Tell us what you think here](https://forms.gle/8Va7ombB793HqFKw5).

## Inputs

### `target_url`

(Required) The full URL (including scheme) of the site to scan.

### `output_filename`

(Optional) The name of the output report file. This is stored in the CIRCLE_WORKING_DIRECTORY (/home/circleci/project) directory.

The default value is `dastardly-report.xml`

### `fail_on_failure`

(Optional) Fails the workflow if the scanner finds any issue with a severity level of `LOW`, `MEDIUM`, or `HIGH` or returns an error.

The default value is `true`

## Results

Dastardly produces a JUnit XML report when the scan completes. This report includes:
* The locations of the vulnerabilities
* Additional information about each vulnerability
* Links to our learning resources, with remediation advice. 

This report only includes vulnerability details if vulnerabilities are found by the scanner. The reporting results example below shows how to save the report.

If Dastardly finds any issue with a severity level of `LOW`, `MEDIUM`, or `HIGH`, it fails a workflow build.

## Examples
Below is an example of how to use the orb by running a Dastardly scan against our [Gin and Juice Shop](https://ginandjuice.shop) site. This is a deliberately vulnerable web application. It's designed for testing web vulnerability scanners.

### Basic Usage
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
        - checkout
        - dastardly/scan:
            target_url: "https://ginandjuice.shop"
            output_filename: "scan_report.xml"

  workflows:
    use-my-orb:
      jobs:
        - scan-example
```

### Reporting Results

The examples below show how to display the vulnerability report in the **Tests** tab using [`store_test_results`](https://circleci.com/docs/configuration-reference/#storetestresults), or to store the raw .xml report as an [artifact](https://circleci.com/docs/artifacts/). CircleCI documentation for collecting test data can be found [here](https://circleci.com/docs/collect-test-data/).

```
usage:
  version: 2.1
  orbs:
    dastardly: portswigger/dastardly-test@1.0.0
  jobs:
    scan-with-test-results:
      machine:
        image: ubuntu-2204:current
      resource_class: medium
      steps:
        - checkout
        - dastardly/scan:
            target_url: "https://ginandjuice.shop"
            output_filename: "scan_report1.xml"
        - store_test_results:
            path: "scan_report1.xml"
    scan-store-artifacts:
      machine:
        image: ubuntu-2204:current
      resource_class: medium
      steps:
        - checkout
        - dastardly/scan:
            target_url: "https://ginandjuice.shop"
            output_filename: "scan_report2.xml"
        - store_test_results:
            path: "scan_report2.xml"
  workflows:
    use-my-orb:
      jobs:
        - scan-with-test-results
        - scan-store-artifact

```