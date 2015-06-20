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
  $path                    = $activemq::config_path,
  $server_config_show_diff = $activemq::server_config_show_diff,
  $system_user             = $activemq::system_user,
  $system_group            = $activemq::system_group,
  $install_from_binary     = $activemq::install_from_binary,
  $log_path                = $activemq::log_path,
) {

  # Resource defaults
  File {
    owner   => $system_user,
    group   => $system_group,
    mode    => '0644',
    notify  => Class['activemq::service'],
    require => Class['activemq::packages'],
  }

  if $server_config_show_diff != 'UNSET' {
    if versioncmp($::puppetversion, '3.2.0') >= 0 {
      File { show_diff => $server_config_show_diff }
    } else {
      warning('show_diff not supported in puppet prior to 3.2, ignoring')
    }
  }

  if $::osfamily == 'Debian' and !$install_from_binary  {
    $available = "/etc/activemq/instances-available/${instance}"
    $path_real = "${available}/activemq.xml"

    file { $available:
      ensure => directory,
    }

    file { "/etc/activemq/instances-enabled/${instance}":
      ensure => link,
      target => $available,
    }
  } else {
    validate_re($path, '^/')
    $path_real = $path
  }

  if $install_from_binary {
    file { $log_path:
      ensure => directory,
    }
  }

  # The configuration file itself.
  file { 'activemq.xml':
    ensure  => file,
    path    => $path_real,
    owner   => $system_user,
    group   => $system_group,
    mode    => '0600',
    content => $server_config,
    notify  => Class['activemq::service'],
  }

}
