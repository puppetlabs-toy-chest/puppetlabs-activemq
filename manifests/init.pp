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
#   Class['stdlib::stages']
#
# Sample Usage:
#
# node default {
#   class { 'activemq': }
# }
#
class activemq(
  $version = '5.5.0-2.el5',
  $ensure  = 'running'
) {

  # JJM FIXME: Input Validation and support for non EL5 systems.
  $version_real = $version
  $ensure_real  = $ensure

  class { 'activemq::packages':
    version => $version_real,
    stage   => 'setup_infra',
  }

  class { 'activemq::config':
    stage   => 'setup_infra',
    require => Class['activemq::packages'],
  }

  class { 'activemq::service':
    ensure  => $ensure_real,
    stage   => 'deploy_infra',
    require => Class['activemq::config'],
  }

}

