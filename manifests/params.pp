# Private
class activemq::params {
  $version       = 'present'
  $package       = 'activemq'
  $ensure        = 'running'
  $instance      = 'activemq'
  $server_config = 'UNSET'

  # Debian does not include the webconsole
  case $::osfamily {
    'Debian': {
      $webconsole = false
    }
    default: {
      $webconsole = true
    }
  }
}
