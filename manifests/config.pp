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
  $instance,
  $package,
  $path = '/etc/activemq/activemq.xml',
  $server_config_show_diff = 'UNSET',
) {

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package[$package],
  }

  if $server_config_show_diff != 'UNSET' {
    if versioncmp($settings::puppetversion, '3.2.0') >= 0 {
      File { show_diff => $server_config_show_diff }
    } else {
      warning('show_diff not supported in puppet prior to 3.2, ignoring')
    }
  }

  $server_config_real = $server_config

  if $::osfamily == 'Debian' {
    $available = "/etc/activemq/instances-available/${instance}"
    $path_real = "${available}/activemq.xml"

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
    path    => $path_real,
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0600',
    content => $server_config_real,
  }

}
