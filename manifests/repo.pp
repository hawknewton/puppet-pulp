# installs the pulp repo
class pulp::repo(
  $ensure = 'present',
  $site = 'http://repos.fedorapeople.org',
  $url = 'repos/pulp/pulp/stable/2/$releasever/$basearch/') {

  if $ensure == 'absent' {
    yumrepo { 'pulp-v2-stable':
      enabled => 'absent'
    }
  } else {
    if $ensure == 'disabled' {
      $enabled = 0
    } else {
      $enabled = 1
    }
    yumrepo { 'pulp-v2-stable':
      enabled  => $enabled,
      baseurl  => "${site}/${url}",
      descr    => 'Pulp v2 Production Releases',
      gpgcheck => 0
    }
  }
}
