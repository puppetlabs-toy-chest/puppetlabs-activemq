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
  $server_config           = $activemq::server_config_content,
  $instance                = $activemq::instance,
  $package                 = $activemq::package,
  $path                    = $activemq::config_path,
  $server_config_show_diff = $activemq::server_config_show_diff,
  $user                    = $activemq::user,
  $group                   = $activemq::group,
) {

  # Resource defaults
  File {
    owner   => $user,
    group   => $group,
    mode    => '0644',
    notify  => Class['activemq::service'],
    require => Class['activemq::packages'],
  }

  if $server_config_show_diff != 'UNSET' {
    if versioncmp($settings::puppetversion, '3.2.0') >= 0 {
      File { show_diff => $server_config_show_diff }
    } else {
      warning('show_diff not supported in puppet prior to 3.2, ignoring')
    }
  }

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
    owner   => $user,
    group   => $group,
    mode    => '0600',
    content => $server_config,
  }

}
