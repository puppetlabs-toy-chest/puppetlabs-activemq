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
  $stomp_user,
  $stomp_passwd,
  $stomp_admin,
  $stomp_adminpw,
  $path = '/opt/activemq/conf/activemq.xml'
) {

  validate_re($path, '^/')
  $path_real = $path

  $server_config_real = $server_config

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Class['activemq::packages'],
  }

  # The configuration file itself.
  file { 'activemq.xml':
    ensure  => file,
    path    => $path_real,
    owner   => '0',
    group   => '0',
    content => $server_config_real,
  }

}
