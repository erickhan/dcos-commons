<p align="left"><img src="https://mesosphere.com/wp-content/themes/mesosphere/library/images/assets/dcos-sdk-logo.png" width="250"/></p>

# Your Name Here

This template README may be used as a starting point for writing a Service Guide for your DC/OS Service.

The parts in _ITALICS_ should be replaced with your own instructions.

Many sections are left unfilled as they depend on how your service works. For example, we leave an empty section for you to describe how users may Backup and Restore their data, because any persistent service should have a backup option.

---

# _SERVICE NAME_

## Overview

DC/OS _SERVICE NAME_ is an automated service that makes it easy to deploy and manage _SERVICE NAME_ on Mesosphere DC/OS. For more information on _SERVICE NAME_, see the _[SERVICE NAME](http://example.com)_ documentation.

The service comes with a reasonable initial configuration for light production use. Additional customizations may be made to the service configuration at initial install, and later updated once the service is already running through a configuration rollout process. If you just want to try out the service, you can use the default configuration and be up and running within moments.

Interoperating clients and services may directly access _SERVICE NAME_ via advertised endpoints, regardless of where the instance is located within a DC/OS Cluster.

Multiple instances can be installed on DC/OS and managed independently. This allows different teams within an organization to have isolated instances of _SERVICE NAME_.

### Benefits

DC/OS _SERVICE NAME_ offers the following benefits:

- [Easy installation](#getting-started)
- [Multiple instances](#multiple-instances)
- [Vertical and horizontal scaling](#scaling-configuration)
- [Flexible persistent storage volumes](#volume-configuration)
- [Replication for high availability](#replication)
- [Backup/Restore](#backup-restore)
- [Integrated monitoring](#monitoring)

## Getting started

1. Get a DC/OS cluster. If you don't have one yet, head over to [DC/OS Docs](https://dcos.io/docs/latest).
2. Install the Service in your DC/OS cluster, either via the [DC/OS Dashboard](https://docs.mesosphere.com/latest/usage/webinterface/) or via the [DC/OS CLI](https://docs.mesosphere.com/latest/usage/cli/) as shown here:
```
dcos config set core.dcos_url http://your-cluster.com
dcos config set core.ssl_verify False # optional
dcos auth login
```
```
dcos package install _PACKAGE NAME_
```
3. The service will now deploy with a default configuration. You can monitor its deployment via the Services UI in the DC/OS Dashboard.
4. Now you are ready to connect a client...

### Connecting clients

#### Discovering endpoints

Once the service is running, you can view information about its advertised endpoints via either of the following methods:
- CLI:
  - List endpoint types: `dcos _PACKAGE NAME_ endpoints`
  - View endpoints for an endpoint type: `dcos _PACKAGE NAME_ endpoints <endpoint>`
- Browser:
  - List endpoint types: `http://yourcluster.com/service/dcos/_PACKAGE NAME_ endpoints`
  - View endpoints for an endpoint type: `dcos _PACKAGE NAME_ endpoints <endpoint>`

Returned endpoints will include the following:
- `.mesos` hostnames for each instance which will follow them if they're moved within the DC/OS cluster.
- A HA-enabled VIP hostname for accessing any of the instances (optional).
- A direct IP address for accesssing the service if `.mesos` hostnames are not resolvable.

In general, the `.mesos` endpoints will only work from within the same DC/OS cluster. From outside the cluster you may either use the direct IPs, or set up a proxy service which acts as a frontend to your _SERVICE NAME_ instance. For development and testing purposes, you may use [DC/OS Tunnel](https://docs.mesosphere.com/latest/administration/access-node/tunnel/) to access services from outside the cluster, but this option is not suitable for production use.

#### Connecting to endpoints

_INSTRUCTIONS FOR CONNECTING A CLIENT TO YOUR SERVICE USING THE RETURNED ENDPOINTS_

## Install and customize

When installing the service without any additional customizations, reasonable defaults are provided.

### Recommendations

By default, DC/OS _SERVICE NAME_ consumes the following resources, suitable for development use:

_UPDATE THESE TO REFLECT YOUR SERVICE_
2 x Example Index Node:
- 1.5 CPUs
- 2 GB Mem
- 10 GB `ROOT` volume

5 x Example Data Node:
- 1 CPU
- 4 GB Mem
- 10 GB `ROOT` volume

In a production environment, resources should be adjusted to the following:

_UPDATE THESE TO REFLECT YOUR SERVICE_
2 x Example Index Node:
- 3 CPUs
- 2 GB Mem
- 10 GB `ROOT` volume

5 x Example Data Node:
- 2 CPUs
- 16 GB Mem
- 100 GB `MOUNT` volume

In a resource-constrained testing environment, resources may be reduced to the following at your own risk:

_UPDATE THESE TO REFLECT YOUR SERVICE_
1 x Example Index Node:
- 0.5 CPUs
- 1 GB Mem
- 5 GB `ROOT` volume

3 x Example Data Node:
- 1 CPU
- 2 GB Mem
- 5 GB `ROOT` volume

### Scaling configuration

DC/OS _SERVICE NAME_ may be configured 

### Volume configuration

### Deployment features

#### Placement constraints

TODO How they work (not migration), how to configure, how to update

#### Strict mode

TODO link EE

#### _OPTIONS SPECIFIC TO YOUR SERVICE GO HERE_

_CREATE ONE OR MORE SECTIONS FOR INFORMATION ABOUT CONFIGURING YOUR SERVICE. FOR EXAMPLE, OPTIONAL FEATURES THAT MAY BE ENABLED/DISABLED BY A CUSTOMER._

### Uninstall


