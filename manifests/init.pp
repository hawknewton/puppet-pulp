class pulp($ensure = 'enabled') { 
  if $ensure == 'enabled' {
    $enabled = 1
  } elsif $ensure == 'disabled' {
    $enabled = 0
  } elsif $ensure == 'absent' {
    $enabled = 'absent'
  }

  stage { 'pulp_repo_setup':
    before => Stage['main']
  }

  class { 'pulp::repo':
    ensure => $ensure,
    stage  => pulp_repo_setup
  }
}
