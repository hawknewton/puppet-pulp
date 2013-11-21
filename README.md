[![Build Status](https://travis-ci.org/hawknewton/puppet-pulp.png?branch=master)](https://travis-ci.org/hawknewton/puppet-pulp)
# Overview
This module makes an honest attempt at installing the
[The Pulp Repository](http://www.pulpproject.org/), including it's consumer and
administration clients, onto a redhat system of your choice.  The Pulp Repo
brings to the table (among other things) the ability to host an internal puppet
repository (like puppetforge but without the pretty web interface).

## Quickstart
* Install an [epel repo](http://puppetforge.com/stahnma/epel)
* Disable [selinux](http://puppetforge.com/spiette/selinux)

Install the server, admin client, and consumer on the same box:

```
class { 'pulp': }               # Install pulp v2 yum repo
clsss { 'pulp::server': }       # Install pulp server
class { 'pulp::admin_client': } # Install admin client
class { 'pulp::consumer': }     # Install pulp agent and client

# Create a puppet repo
puppet_repo { 'repo_id':
  # Default pulp admin login/password
  ensure       => 'present',
  login        => 'admin',
  password     => 'admin',
  display_name => 'my test repo',
  description  => "I lifted this repo from the pulp puppet module and didn't change the description!",
  feed         => 'http://forge.puppetlabs.com',
  queries      => ['query1', 'query2'],
  serve_http   => true,
  serve_https  => true
  notes        => {
    'note1' => 'value 1',
    'note2' => 'value 2'
  }
}
```

The default configuration is rather nieve.  It does nothing beyond what's outlined
int The Pulp's [installation section](http://pulp-user-guide.readthedocs.org/en/pulp-2.2/installation.html).
If you want to use this for real you'll likely want to provide additional configuration
to secure and customize your installation.

## Installation
Detailed information is avaialble in the [installation section](https://pulp-user-guide.readthedocs.org/en/pulp-2.2/installation.html)
of The Pulp [user guide](https://pulp-user-guide.readthedocs.org/en/pulp-2.2/index.html)

### Supported Operating Systems

#### Server
* RHEL 6
* Fedora 17 & 18
* CentOS 6

#### Consumer
* RHEL 5 & 6
* Fedora 17 & 18
* CentOS 6

### Module Prerequisites
This module needs a few thing to make it go:
* The EPEL repo of your choice.  I tested using `stahnma/epel`, which seems as
  good as any.

* You'll need to disable selinux.

### Usage

#### Class pulp
Installs a local pulp v2 yumrepo.

```
class { 'pulp':
  ensure => 'present'
}

```

##### Parameters
**ensure**
* `enabled`: Install the pulp yumrepo and enable it
* `diabled`: Install and pulp yumrepo and leave it disabled
* `absent`: Remove any yumrepo called `pulp-v2-stable`

If you want to manage the pulp repo yourself, don't include the pulp class.

#### Class pulp::server
Fires up a pulp server, including mongo, qpid, and httpd.

```
class { 'pulp::server':
  ensure => 'present'
}
```

##### Parametres:
**ensure** (defaults to `present`)
* `present`: install the pulp server at the current version
* `2.2.0-1.el6` (for example): pin the pulp server at a specific verion
* `absent`: remove the pulp server, shut down services, and delete config files

**conf_template** (optional)

If provided, use this template instead of the built-in `templates/server.conf.erb`

#### Class pulp::admin_client
Installs and configures the pulp admin client.

```
class { 'pulp::admin_client':
  ensure => 'present'
}
```

##### Parameters:
**ensure** -- optional, defaults to `present`
* `present`: Install the pulp admin client at the current version
* `2.2.0-1.el6` (for example): pin the client to a specific verison
* `absent`: remove the admin client

**server** -- optional, defaults to the current host

**conf_template**  -- optional

If provided, use this template instead of the built-in `templates/admon.conf.erb`

#### Class pulp::consumer
Installs and configures the pulp consumer.
```
class { 'pulp::consumer':
  ensure => 'present'
}
```

##### Parameters:
**ensure** -- optional, defaults to `present`
* `present`: Install the pulp consumer at the current version
* `2.2.0-1.el6` (for example): pin the client ot a specific verison
* `absent`: Remove the pulp-consumer packages

**server** -- optional, defaults to the current host

**conf_template** -- optional

If provided, use this template instead of the built-in `templates/consumer.conf.erb`

#### Type puppet_repo
Sets up a puppet module repository on your pulp server
```
puppet_repo { 'repo_id':
  # Default pulp admin login/password
  ensure       => 'present',
  login        => 'admin',
  password     => 'admin',
  display_name => 'my test repo',
  description  => "I lifted this repo from the pulp puppet module and didn't change the description!",
  feed         => 'http://forge.puppetlabs.com',
  queries      => ['query1', 'query2'],
  serve_http   => true,
  serve_https  => true
  notes        => {
    'note1' => 'value 1',
    'note2' => 'value 2'
  }
}
```

##### Parameters:
**ensure** -- required, may be `present` or `absent`
* `present`: Ensure the repo exists
* `absent`: Ensure the repo doesn't exist

**login** -- Login to your pulp repo (think `pulp-admin login`)
**password** -- Password to your pulp repo (think `pulp-admin login`)
**display_name** -- optional, the display name for your repo
**description** -- optional, the description for your repo
**feed** -- optional, feed url for your repo
**queries** -- optional, queries for your repo, see `pulp-admin puppet repo create`
**serve_http** -- optional defaults to true, serve the repo via http
**serve_https** -- optional optionals to false, serve the repo via https
**notes** -- optional map, notes for your repo, see `pulp-admin puppet repo create`.  An empty map has no effect, to remove a note set the value to an empty string


## Developing

If you want to issue a pull request, that'd be awesome.
Make sure you have a fairly recent version of both vagrant and ruby, then do this:

```
bundle install
bundle exec rake spec spec:system
```

## TODO
* Fail when we're being installed on an unsupported OS
* Enable the installation of puppet modules on a puppetmaster
