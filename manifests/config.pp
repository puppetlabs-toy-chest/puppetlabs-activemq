# Class: activemq::config
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::config (
  $server_config,
  $wrapper_config,
  $instance,
  $path = '/etc/activemq',
) {

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0640',
    notify  => Service['activemq'],
    require => Package['activemq'],
  }

  $server_config_real = $server_config
  $wrapper_config_real = $wrapper_config

  if $::osfamily == 'Debian' {
    $available = "/etc/activemq/instances-available/${instance}"
    $path_real = "${available}"

    file { $available:
      ensure => directory,
    }

    file { "/etc/activemq/instances-enabled/${instance}":
      ensure => link,
      target => $available,
    }
  }
  else {
    validate_re($path, '^/')
    $path_real = $path
  }

  # The configuration file itself.
  file { 'activemq.xml':
    ensure  => file,
    path    => "${path_real}/activemq.xml",
    content => $server_config_real,
  }

  # The wrapper configuration file itself.
  file { 'activemq-wrapper.conf':
    ensure  => file,
    path    => "${path_real}/activemq-wrapper.conf",
    content => $wrapper_config_real,
  }

}
