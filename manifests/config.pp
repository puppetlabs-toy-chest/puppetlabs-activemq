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
  $path = '/etc/activemq/activemq.xml',
  $brokername = 'localhost'
) {

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package['activemq'],
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
    owner   => '0',
    group   => '0',
    content => $server_config_real,
  }

}

class activemq::webconsole(
  $auth = true,
  $interface = 'all',
  $password = 'msgbusadminsecret'
){

  $real_interface = $interface ? {
    'all' => '0.0.0.0',
    default => $interface
  }

  file {'jetty.xml':
    ensure  => file,
    path    => '/etc/activemq/jetty.xml',
    owner   => '0',
    group   => '0',
    content =>  template("${module_name}/jetty.xml.erb")
  }

  file {'jetty-realm.properties':
    ensure  => file,
    path    => '/etc/activemq/jetty-realm.properties',
    owner   => '0',
    group   => '0',
    content => template("${module_name}/jetty-realm.properties.erb")
  }
}
