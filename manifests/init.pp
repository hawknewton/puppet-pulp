# main pulp class
class pulp (
  $ensure = 'enabled',
  $proxy = undef
) {
  if $ensure == 'enabled' {
    $enabled = 1
  } elsif $ensure == 'disabled' {
    $enabled = 0
  } elsif $ensure == 'absent' {
    $enabled = 'absent'
  } else {
    fail('expected ensure to be enabled, disabled or absent')
  }

  if ($proxy) {
    validate_re($proxy, '^http.*')
  }

  stage { 'pulp_repo_setup':
    before => Stage['main']
  }

  class { 'pulp::repo':
    ensure => $ensure,
    stage  => pulp_repo_setup,
    proxy  => $proxy,
  }
}
