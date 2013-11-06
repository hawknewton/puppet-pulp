[![Build Status](https://travis-ci.org/hawknewton/puppet-pulp.png?branch=master)](https://travis-ci.org/hawknewton/puppet-pulp)
# Overview
This module makes an honest attempt at installing the
[The Pulp Repository](http://www.pulpproject.org/), including it's consumer and
administration clients, onto a redhat system of your choice.  The Pulp Repo
brings to the table (among other things) the ability to host an internal puppet
forge.

## Installation

### Prerequisites
This module needs a few thing to make it go:
* The EPEL repo of your choice.  I tested using `stahnma/epel`, which seems as
  good as any.

* You'll need to disable selinux.

### Usage

#### class pulp
Include pulp:
```
class { 'pulp':
  ensure => 'present'
}

```
This installs the pulp-v2 repo.  Values for ensure include:
* **enabled**: Install the pulp yumrepo and enable it
* **diabled**: Install and pulp yumrepo and leave it disabled
* **absent**: Remove any yumrepo called `pulp-v2-stable`

If you want to manage the pulp repo yourself, don't include the pulp class


