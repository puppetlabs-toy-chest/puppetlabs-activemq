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
  $path = '/etc/activemq/activemq.xml'
) {

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package['activemq'],
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

  if $server_config {
    $source = $server_config
    $content = undef
  } else {
    $source = undef
    $content = template("${module_name}/activemq.xml.erb")
  }

  # The configuration file itself.
  file { 'activemq.xml':
    ensure  => file,
    path    => $path_real,
    owner   => '0',
    group   => '0',
    content => $content,
    source  => $source
  }

}
