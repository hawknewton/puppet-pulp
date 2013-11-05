class pulp($ensure = 'enabled') { 
  if $ensure == 'enabled' {
    $enabled = 1
  } elsif $ensure == 'disabled' {
    $enabled = 0
  } elsif $ensure == 'absent' {
    $enabled = 'absent'
  }

  yumrepo {'pulp-v2-stable':
    enabled  => $enabled,
    baseurl  => 'http://repos.fedorapeople.org/repos/pulp/pulp/stable/2/$releasever/$basearch/',
    descr    => 'Pulp v2 Production Releases',
    gpgcheck => 0
  }
}
