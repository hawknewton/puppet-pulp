class pulp::server($ensure = 'present') {

  if $ensure == 'absent' {
    package { [ 'pulp-server',
                'pulp-puppet-plugins',
                'pulp-rpm-plugins',
                'pulp-selinux']:
      ensure => 'absent'
    }

    file { '/etc/pulp/server.conf':
      ensure => 'absent'
    }

    service { [ 'mongod', 'qpidd' ]:
      ensure => 'stopped'
    }
  } else {
    package { [ 'pulp-server',
                'pulp-puppet-plugins',
                'pulp-rpm-plugins',
                'pulp-selinux']:
      ensure => $ensure,
      notify => Exec['setup-pulp-db'],
      before => [Service['mongod'], Service['qpidd']];
              'httpd':
      ensure => 'present'
    }

    file { '/etc/pulp/server.conf':
      owner  => 'root',
      group  => 'root',
      ensure => 'present',
      mode   => 644,
      require  => Package['pulp-server']
    }

    service { [ 'mongod', 'qpidd']:
      ensure  => 'running',
      require => File['/etc/pulp/server.conf']
    }

    # The mongod service script doesn't block, so we'll keep trying
    # this for up to two minutes
    exec { 'setup-pulp-db':
      command     => '/usr/bin/pulp-manage-db',
      refreshonly => true,
      tries       => 12,
      try_sleep   => 10,
      require     => [Service['mongod'], Service['qpidd']]
    }

    service { 'httpd':
      ensure    => 'running',
      subscribe => Exec['setup-pulp-db']
    }
  }
}
