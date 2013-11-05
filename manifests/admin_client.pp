class pulp::admin_client($ensure = 'present', $conf_template = '') {
  package { [ 'pulp-admin-client',
              'pulp-puppet-admin-extensions',
              'pulp-rpm-admin-extensions']:
    ensure => $ensure
  }

  if $conf_template == '' {
    $template = 'pulp/admin.conf.erb'
  } else {
    $template = $conf_template
  }

  if $ensure == 'absent' {
    file { '/etc/pulp/admin/admin.conf':
      ensure => 'absent'
    }
  } else {
    file { '/etc/pulp/admin/admin.conf':
      ensure  => 'present',
      content => template($template)
    }
  }
}
