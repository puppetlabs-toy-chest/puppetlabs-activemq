# Class: activemq
#
# This module manages the ActiveMQ messaging middleware.
#
# Parameters:
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
  $version       = 'present',
  $ensure        = 'running',
  $server_config = 'UNSET'
) {

  # Arrays cannot take anonymous arrays in Puppet 2.6.8
  $v_ensure = [ '^running$', '^stopped$' ]
  validate_re($ensure, $v_ensure)
  validate_re($version, '^[._0-9a-zA-Z:-]+$')

  $version_real = $version
  $ensure_real  = $ensure

  # Since this is a template, it should come _after_ all variables are set for
  # this class.
  $server_config_real = $server_config ? {
    'UNSET' => template("${module_name}/activemq.xml.erb"),
    default => $server_config,
  }

  class { 'activemq::packages':
    version => $version_real,
    require => Class['java'],
  }

  class { 'activemq::config':
    server_config => $server_config_real,
    require       => Class['activemq::packages'],
  }

  class { 'activemq::service':
    ensure    => $ensure_real,
    subscribe => Class['activemq::config'],
  }

}

