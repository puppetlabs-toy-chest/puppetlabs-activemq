# Class: activemq
#
# This module manages the ActiveMQ messaging middleware.
#
# Parameters:
#
#    [*version*]            - ActiveMQ version
#    [*ensure*]             - ActiveMQ service parameter
#    [*instance*]           - ActiveMQ instance
#    [*webconsole*]         - Boolean flag for installing the webconsole
#    [*server_config*]      - Configuration for ActiveMQ
#    [*wrapper_config*]     - Configuration for ActiveMQ wrapper
#    [*java_max_memory*]    - Maximum Java Heap Size for ActiveMQ (in MB)
#    [*admin_user*]         - Admin username
#    [*admin_passwd*]       - Admin password
#    [*mcollective_user*]   - MCollective username
#    [*mcollective_passwd*] - MCollective password
#    [*openwire_port*]      - Openwire port (use 'UNSET' to disable)
#    [*stomp_port*]         - Stomp port (use 'UNSET' to disable)
#
# Actions:
#
# Requires:
#
#   Class['java']
#
# Sample Usage:
#
# node default {
#   class { 'activemq': }
# }
#
# To supply your own configuration file:
#
# node default {
#   class { 'activemq':
#     server_config => template('site/activemq.xml.erb'),
#   }
# }
#
class activemq(
  $version              = 'present',
  $ensure               = 'running',
  $instance             = 'activemq',
  $webconsole           = true,
  $server_config        = 'UNSET',
  $wrapper_config       = 'UNSET',
  $java_max_memory      = 512,
  $admin_user           = 'admin',
  $admin_passwd         = 'secret',
  $mcollective_user     = 'mcollective',
  $mcollective_passwd   = 'marionette',
  $openwire_port        = 6166,
  $stomp_port           = 6163,
) {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)

  $version_real = $version
  $ensure_real  = $ensure
  $webconsole_real = $webconsole

  # Since this is a template, it should come _after_ all variables are set for
  # this class.
  $server_config_real = $server_config ? {
    'UNSET' => template("${module_name}/activemq.xml.erb"),
    default => $server_config,
  }
  $wrapper_config_real = $wrapper_config ? {
    'UNSET' => template("${module_name}/activemq-wrapper.conf.erb"),
    default => $wrapper_config,
  }

  # Anchors for containing the implementation class
  anchor { 'activemq::begin':
    before => Class['activemq::packages'],
    notify => Class['activemq::service'],
  }

  class { 'activemq::packages':
    version => $version_real,
    notify  => Class['activemq::service'],
  }

  class { 'activemq::config':
    instance       => $instance,
    server_config  => $server_config_real,
    wrapper_config => $wrapper_config_real,
    require        => Class['activemq::packages'],
    notify         => Class['activemq::service'],
  }

  class { 'activemq::service':
    ensure => $ensure_real,
  }

  anchor { 'activemq::end':
    require => Class['activemq::service'],
  }

}

