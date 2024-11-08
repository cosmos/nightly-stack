# Nightly Build

![Knight Battle testing](./knightly.jpeg)

This repository contains the nightly builds of the Interchain Stack. The Interchain Stack is a collection of software that enables the creation of decentralized applications that are interoperable with other blockchains. The stack includes the Cosmos SDK, IBC, and CW.

## Long-Lived testnets

We currently are running multiple testnets, each one running a specific versions of cosmos-sdk.
Binary Builds validators are updated daily, with the latest commits on both sdk and modules. The complete update logic can be found in `.github/scripts/update-go-modules.sh`

### Status
https://status.interchainsdk.io/status/testnets

### Live Chains
- 0-50-1
- 0-52-1
- v2-0-52-1


## Nightlies Scheduled workflow

The workflow runs once a day, and will publish artifacts (binary and container image) following the specification inside .`/apps/<app_name>/metadata.yaml`

### Essential Files

The following files play critical roles in ensuring the proper execution of the workflow:

#### In the ./apps/<app_name>/ directory:

1. `ci/` (directory)
   - Contains scripts and configurations for Continuous Integration.

2. `Dockerfile`
   - Defines the container image for building and running the application in a production environment.

3. `entrypoint.sh`
   - Shell script that serves as the entry point for the container.
   - Must init the blockchain if necessary.

4. `metadata.yaml`
   - Contains informations about how to build the application.

#### In the ./apps//<app_name>/ci/ directory:

1. `build.sh`
   - Script responsible for building the application.

2. `goss.yaml`
   - Configuration file for Goss, a server testing tool.
   - Defines tests to validate the correctness of the built container.

3. `test.sh`
   - Script for running tests on the application.
   - Will check if blocks are produced on a short-lived testnet.


### metadata.yaml configuration Structure

The YAML file consists of several top-level fields and a `channels` section with channel-specific configurations.

#### Top-level Fields

```yaml
app: ignite-example
repository: ignite/example
path: ./
fetch_full_history: true
publish_artifacts: true
binary_name: exampled
```

- app: The name of your application.
- repository: The GitHub repository where your application is hosted.
- path: The path to the application's root directory within the repository.
- fetch_full_history: Whether to fetch the full Git history (true/false).
- publish_artifacts: Whether to publish build artifacts (true/false).
- binary_name: The name of the compiled binary.

#### Channels Configuration
The channels section allows you to define multiple build configurations, each with its own settings.

```yaml
channels:
- name: master
    platforms: [&quot;linux/amd64&quot;]
    branch: master
    container_tag_name: master
    update_modules:
      enabled: false
    tests_enabled: true
```
- name: A unique identifier for the channel.
- platforms: A list of target platforms for building (e.g., "linux/amd64").
- branch: The Git branch to use for this channel.
- container_tag_name: The tag to use for the built container image.
- update_modules.enabled: Whether to update modules (true/false).
- update_modules.cosmossdk_branch: Specify a specific branch from the cosmos/cosmos-sdk repository.
- tests_enabled: Whether to run tests using the built artefacts (true/false).
